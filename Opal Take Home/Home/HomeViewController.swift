//
//  HomeViewController.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController: UIViewController {
    // placeholder view controller to present RewardsViewController modally
    // Pass through number of referrals to mock data
    private lazy var rewardsView: ReferralEntryView = {
        let view = ReferralEntryView()
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(color: .mutedBackground)

        view.addSubview(rewardsView)
        rewardsView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-64)
            $0.height.width.equalTo(300)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rewardsView.textField.becomeFirstResponder()
    }
}

extension HomeViewController: RewardsViewDelegate {
    func finishPassing(referralCount: Int, proUser: Bool) {
        DispatchQueue.main.async {
            let vc = RewardsViewController(viewModel: RewardsViewModel(serviceContainer: ServiceContainer.shared, referralCount: referralCount, proUser: proUser))
            self.present(vc, animated: true)
        }
    }
}

