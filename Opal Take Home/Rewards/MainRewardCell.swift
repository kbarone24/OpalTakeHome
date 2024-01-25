//
//  MainRewardCell.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation
import UIKit

class MainRewardCell: UITableViewCell {
    weak var delegate: RewardCellDelegate?
    private var rewardID: String?

    private lazy var rewardContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        view.layer.cornerRadius = 18
        return view
    }()

    private lazy var rewardBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        view.layer.cornerRadius = 14
        return view
    }()

    private lazy var rewardIcon = UIImageView()

    private lazy var rewardDetailContainer = UIView()

    private lazy var labelAttributes: [NSAttributedString.Key: Any] = {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.15
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: 0.07,
            .paragraphStyle: style
        ]
        return attributes
    }()

    private lazy var friendLabel = GradientLabel(font: UIFont(name: Font.OpalSemibold.name, size: 11))

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(color: Color.textPrimary)
        label.font = TextStyle.header.font
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(color: Color.textSecondary)
        label.font = TextStyle.mutedParagraph.font
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private lazy var claimButton: ClaimButton = {
        let button = ClaimButton()
        button.addTarget(self, action: #selector(claimTap), for: .touchUpInside)
        return button
    }()

    private lazy var gradientProgressView = GradientProgressView()

    let config = UIImage.SymbolConfiguration(
        pointSize: TextStyle.largeButton.font.pointSize,
        weight: .regular
    )

    private lazy var downArrow: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(
                symbol: .downArrow,
                configuration: config
            )?.withTintColor(UIColor(red: 0.46, green: 0.47, blue: 0.47, alpha: 1.00))
        )
        imageView.alpha = 0.4
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(color: .mutedBackground)

        contentView.addSubview(rewardContainer)
        rewardContainer.snp.makeConstraints {
            $0.top.equalTo(4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        rewardContainer.addSubview(rewardBackground)
        rewardBackground.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.height.width.equalTo(100)
            $0.centerY.equalToSuperview()
            $0.top.bottom.lessThanOrEqualToSuperview().inset(16)
        }

        rewardIcon.clipsToBounds = true
        rewardBackground.addSubview(rewardIcon)
        rewardIcon.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        rewardContainer.addSubview(rewardDetailContainer)
        rewardDetailContainer.snp.makeConstraints {
            $0.top.bottom.lessThanOrEqualToSuperview().inset(16)
            $0.leading.equalTo(rewardBackground.snp.trailing).offset(32)
            $0.trailing.equalTo(-16)
            $0.centerY.equalToSuperview()
        }

        rewardDetailContainer.addSubview(friendLabel)
        friendLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        rewardDetailContainer.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(friendLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }

        rewardDetailContainer.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
        }

        rewardDetailContainer.addSubview(claimButton)
        rewardDetailContainer.addSubview(gradientProgressView)

        contentView.addSubview(downArrow)
        downArrow.snp.makeConstraints {
            $0.top.equalTo(rewardContainer.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-8)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientProgressView.updateView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(reward: Reward, userProfile: UserProfile, lastRow: Bool) {
        self.rewardID = reward.id

        rewardContainer.backgroundColor = reward.selectedReward ? UIColor.white.withAlphaComponent(0.05) : UIColor(color: .mutedBackground)
        rewardIcon.image = UIImage(asset: UIImage.Asset(rawValue: reward.name.caseName) ?? .MysteryGift)

        var friendText = "\(reward.referralCriteria) FRIEND"
        if reward.referralCriteria != 1 { friendText += "S" }
        friendLabel.configure(text: friendText, colors: userProfile.selectedTheme.colors)

        nameLabel.attributedText = NSAttributedString(string: reward.name.rawValue, attributes: labelAttributes)
        descriptionLabel.attributedText = NSAttributedString(string: reward.description, attributes: labelAttributes)

        let userReferralCount = userProfile.referredFriendIDs.count
        let rewardIsUnlocked = userReferralCount >= reward.referralCriteria

        if rewardIsUnlocked {
            gradientProgressView.isHidden = true

            claimButton.isHidden = false
            claimButton.isEnabled = !reward.claimed

            addClaimConstraints()

        } else {
            claimButton.isHidden = true

            gradientProgressView.isHidden = false
            gradientProgressView.setProgress(Float(userReferralCount) / Float(reward.referralCriteria), animated: false)
            gradientProgressView.colors = userProfile.selectedTheme.colors

            addGradientConstraints()
        }

        downArrow.isHidden = lastRow

        layoutIfNeeded()
    }

    private func addGradientConstraints() {
        gradientProgressView.snp.removeConstraints()
        claimButton.snp.removeConstraints()

        gradientProgressView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            $0.height.equalTo(6)
        }
    }

    private func addClaimConstraints() {
        gradientProgressView.snp.removeConstraints()
        claimButton.snp.removeConstraints()

        claimButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            $0.width.equalTo(100)
            $0.height.equalTo(32)
            $0.bottom.equalToSuperview()
        }
    }

    @objc private func claimTap() {
        if let rewardID {
            DispatchQueue.main.async {
                HapticGenerator.shared.play(.light)
                self.delegate?.claim(rewardID: rewardID)
            }
        }
    }
}
