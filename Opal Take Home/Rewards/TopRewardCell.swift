//
//  TopRewardCell.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation
import UIKit

protocol RewardCellDelegate: AnyObject {
    func openShareSheet()
    func claim(rewardID: String)
}

class TopRewardCell: UITableViewCell {
    weak var delegate: RewardCellDelegate?
    private var rewardID: String?

    // TODO: dashed border
    private lazy var rewardContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
        view.layer.cornerRadius = 17
        return view
    }()

    private lazy var labelAttributes: [NSAttributedString.Key: Any] = {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.15
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: 0.07,
            .paragraphStyle: style
        ]
        return attributes
    }()

    private lazy var referredFriendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Referred friends:"
        label.textColor = UIColor(color: .textPrimary)
        label.font = TextStyle.topRewardHeader.font
        return label
    }()

    let friendConfig = UIImage.SymbolConfiguration(pointSize: TextStyle.header.font.pointSize, weight: .regular)
    private lazy var friendIcon = UIImageView(image: UIImage(symbol: .person, configuration: friendConfig))

    // TODO: add profile pic previews
    private lazy var referralCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(color: .textPrimary)
        label.font = TextStyle.header.font
        return label
    }()

    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        return view
    }()

    private lazy var rewardBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var rewardIcon = UIImageView()

    private lazy var rewardDetailContainer = UIView()

    private lazy var unlockLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(color: .textSecondary)
        label.font = TextStyle.subheader.font
        return label
    }()

    private lazy var rewardName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(color: .textPrimary)
        label.font = TextStyle.topRewardHeader.font
        return label
    }()

    private lazy var claimButton: ClaimButton = {
        let button = ClaimButton()
        button.addTarget(self, action: #selector(claimTap), for: .touchUpInside)
        return button
    }()

    private lazy var progressCount: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(color: .textSecondary)
        label.font = TextStyle.subheader.font
        return label
    }()

    private lazy var gradientProgressView = GradientProgressView()

    let buttonConfig = UIImage.SymbolConfiguration(pointSize: TextStyle.largeButton.font.pointSize, weight: .semibold)
    private lazy var addFriendsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(color: .opalBlue)
        button.layer.cornerRadius = 18
        button.setAttributedTitle(
            image: UIImage(
                symbol: .addPerson,
                configuration: buttonConfig)?.withTintColor(.white) ?? UIImage(),
            text: " Add Friends",
            color: .white)
        button.addTarget(self, action: #selector(openShareSheet), for: .touchUpInside)
        return button
    }()

    private lazy var shareLinkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 18
        button.setAttributedTitle(
            image: UIImage(
                symbol: .sendArrow,
                configuration: buttonConfig)?.withTintColor(.black) ?? UIImage(),
            text: " Share Referral Link",
            color: .black)
        button.addTarget(self, action: #selector(openShareSheet), for: .touchUpInside)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(color: .mutedBackground)

        contentView.addSubview(rewardContainer)
        rewardContainer.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(158)
        }

        rewardContainer.addSubview(referredFriendsLabel)
        referredFriendsLabel.snp.makeConstraints {
            $0.leading.equalTo(12)
            $0.top.equalTo(16)
        }

        rewardContainer.addSubview(referralCountLabel)
        referralCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(-16)
            $0.bottom.equalTo(referredFriendsLabel)
        }

        rewardContainer.addSubview(friendIcon)
        friendIcon.snp.makeConstraints {
            $0.trailing.equalTo(referralCountLabel.snp.leading).offset(-3)
            $0.bottom.equalTo(referralCountLabel)
        }

        rewardContainer.addSubview(separatorLine)
        separatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.equalTo(friendIcon.snp.bottom).offset(16)
            $0.height.equalTo(1)
        }

        rewardContainer.addSubview(rewardBackground)
        rewardBackground.clipsToBounds = true
        rewardBackground.snp.makeConstraints {
            $0.leading.equalTo(12)
            $0.width.equalTo(70)
            $0.height.equalTo(72)
            $0.centerY.equalToSuperview().offset(24)
        }

        rewardBackground.addSubview(rewardIcon)
        rewardIcon.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.lessThanOrEqualToSuperview()
        }

        rewardContainer.addSubview(rewardDetailContainer)
        rewardDetailContainer.snp.makeConstraints {
            $0.leading.equalTo(rewardBackground.snp.trailing).offset(12)
            $0.trailing.equalTo(-12)
            $0.centerY.equalTo(rewardBackground)
        }

        rewardDetailContainer.addSubview(unlockLabel)
        unlockLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }

        // constraints set on config
        rewardDetailContainer.addSubview(rewardName)

        rewardDetailContainer.addSubview(progressCount)
        progressCount.snp.makeConstraints {
            $0.centerY.equalTo(rewardName)
            $0.trailing.equalTo(-12)
        }

        rewardDetailContainer.addSubview(claimButton)
        claimButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.equalTo(64)
            $0.height.equalTo(32)
        }

        // constraints set on config
        rewardDetailContainer.addSubview(gradientProgressView)

        contentView.addSubview(addFriendsButton)
        addFriendsButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(rewardContainer.snp.bottom).offset(32)
            $0.height.equalTo(36)
        }

        contentView.addSubview(shareLinkButton)
        shareLinkButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(addFriendsButton.snp.bottom).offset(8)
            $0.height.equalTo(36)
            $0.bottom.equalTo(-24)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(reward: Reward, userProfile: UserProfile) {
        self.rewardID = reward.id

        let userReferralCount = userProfile.referredFriendIDs.count
        referralCountLabel.attributedText = NSAttributedString(string: String(userReferralCount), attributes: labelAttributes)
        rewardIcon.image = UIImage(asset: UIImage.Asset(rawValue: reward.name.caseName) ?? .MysteryGift)

        let rewardIsUnlocked = userReferralCount >= reward.referralCriteria
        let unlockString = rewardIsUnlocked ? "New unlock:" : "Next Unlock:"
        unlockLabel.attributedText = NSAttributedString(string: unlockString, attributes: labelAttributes)

        rewardName.attributedText = NSAttributedString(string: reward.name.rawValue, attributes: labelAttributes)

        let progressString = "\(userReferralCount)/\(reward.referralCriteria)"
        progressCount.attributedText = NSAttributedString(string: progressString, attributes: labelAttributes)

        // claim button will only show when reward can be claimed
        if rewardIsUnlocked {
            progressCount.isHidden = true
            gradientProgressView.isHidden = true

            claimButton.isHidden = false
            claimButton.isEnabled = !reward.claimed

            removeGradientConstraints()

        } else {
            claimButton.isHidden = true

            progressCount.isHidden = false
            gradientProgressView.isHidden = false
            gradientProgressView.setProgress(Float(userReferralCount) / Float(reward.referralCriteria), animated: false)
            gradientProgressView.colors = userProfile.selectedTheme.colors

            addGradientConstraints()
        }

        layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientProgressView.updateView()
    }

    private func removeGradientConstraints() {
        gradientProgressView.snp.removeConstraints()
        rewardName.snp.removeConstraints()
        
        rewardName.snp.makeConstraints {
            $0.leading.equalTo(unlockLabel)
            $0.top.equalTo(unlockLabel.snp.bottom).offset(2)
            $0.bottom.equalToSuperview()
        }
    }

    private func addGradientConstraints() {
        gradientProgressView.snp.removeConstraints()
        rewardName.snp.removeConstraints()

        gradientProgressView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(rewardName.snp.bottom).offset(8)
            $0.height.equalTo(6)
            $0.bottom.equalToSuperview()
        }

        rewardName.snp.makeConstraints {
            $0.leading.equalTo(unlockLabel)
            $0.top.equalTo(unlockLabel.snp.bottom).offset(2)
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

    @objc private func openShareSheet() {
        DispatchQueue.main.async {
            HapticGenerator.shared.play(.soft)
            self.delegate?.openShareSheet()
        }
    }
}
