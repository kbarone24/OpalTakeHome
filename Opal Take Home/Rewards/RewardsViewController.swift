//
//  ViewController.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/23/24.
//

import UIKit
import Combine

class RewardsViewController: UIViewController {
    enum Section: Hashable {
        case topReward(gemTheme: GemTheme)
        case main
    }

    enum Item: Hashable {
        case topCell(reward: Reward, userProfile: UserProfile)
        case mainCell(reward: Reward, userProfile: UserProfile)
    }

    private let viewModel: RewardsViewModel
    typealias Input = RewardsViewModel.Input
    typealias Output = RewardsViewModel.Output
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias DataSource = UITableViewDiffableDataSource<Section, Item>

    let refresh = PassthroughSubject<Bool, Never>()
    var subscriptions = Set<AnyCancellable>()

    private(set) lazy var datasource: DataSource = {
        let dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
            switch item {
            case .topCell(reward: let reward, userProfile: let userProfile):
                let cell = tableView.dequeueReusableCell(withIdentifier: TopRewardCell.reuseID, for: indexPath) as? TopRewardCell
                cell?.configure(reward: reward, userProfile: userProfile)
                cell?.delegate = self
                return cell ?? UITableViewCell()
            case .mainCell(reward: let reward, userProfile: let userProfile):
                let cell = tableView.dequeueReusableCell(withIdentifier: MainRewardCell.reuseID, for: indexPath) as? MainRewardCell

                // determine if this is the last row to hide down arrow
                let snapshot = self?.datasource.snapshot()
                guard let sectionIdentifier = snapshot?.sectionIdentifier(containingItem: item),
                      let lastItem = snapshot?.itemIdentifiers(inSection: sectionIdentifier).last else {
                    return UITableViewCell()
                }
                let lastRowInSection = item == lastItem

                cell?.configure(reward: reward, userProfile: userProfile, lastRow: lastRowInSection)
                cell?.delegate = self
                return cell
            }
        }
        return dataSource
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.backgroundColor = UIColor(color: Color.mutedBackground)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedSectionHeaderHeight = 300
        tableView.estimatedRowHeight = 250
        tableView.register(GuestPassHeader.self, forHeaderFooterViewReuseIdentifier: GuestPassHeader.reuseID)
        tableView.register(TopRewardCell.self, forCellReuseIdentifier: TopRewardCell.reuseID)
        tableView.register(MainRewardCell.self, forCellReuseIdentifier: MainRewardCell.reuseID)
        return tableView
    }()


    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .white
        view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        return view
    }()

    private lazy var pullHandle = UIImageView(image: UIImage(asset: .Handle))

    init(viewModel: RewardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        view.addSubview(pullHandle)
        pullHandle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(16)
            $0.width.equalTo(40)
            $0.height.equalTo(4)
        }

        tableView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(100)
            $0.width.height.equalTo(30)
        }
        activityIndicator.startAnimating()

        let input = Input(refresh: refresh)
        let output = viewModel.bind(to: input)
        output.snapshot
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                self?.datasource.apply(snapshot, animatingDifferences: false)
                self?.activityIndicator.stopAnimating()
            }
            .store(in: &subscriptions)

        refresh.send(true)
    }
}

extension RewardsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let snapshot = datasource.snapshot()
        guard !snapshot.sectionIdentifiers.isEmpty else { return 0 }

        let section = snapshot.sectionIdentifiers[section]
        switch section {
        case .topReward(gemTheme: _):
            return UITableView.automaticDimension
        case .main:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !datasource.snapshot().sectionIdentifiers.isEmpty else { return UIView() }
        let section = datasource.snapshot().sectionIdentifiers[section]
        switch section {
        case .topReward(gemTheme: let gemTheme):
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GuestPassHeader.reuseID) as? GuestPassHeader
            header?.configure(theme: gemTheme)
            return header
        case .main:
            return UIView()
        }
    }
}

extension RewardsViewController: RewardCellDelegate {
    func claim(rewardID: String) {
        viewModel.updateClaimedRewards(rewardID: rewardID)
        refresh.send(false)
    }

    func openShareSheet() {
        guard let url = URL(string: "https://link.opal.so/1z4JyKYp8SAEVPfL9") else { return }
        let items = [url, "Find your focus with Opal!"] as [Any]

        DispatchQueue.main.async {
            let activityView = UIActivityViewController(activityItems: items, applicationActivities: nil)

            // iPad support
            if let popoverController = activityView.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }

            self.present(activityView, animated: true)
        }
    }
}
