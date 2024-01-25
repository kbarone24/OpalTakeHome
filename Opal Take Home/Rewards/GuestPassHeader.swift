//
//  GuestPassView.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation
import UIKit

class GuestPassHeader: UITableViewHeaderFooterView {
    private var colors = [UIColor]()

    private lazy var passBackground: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.05).cgColor
        view.alpha = 0.9
        view.clipsToBounds = true
        return view
    }()

    private lazy var seal: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(asset: .SealWhite)
        view.contentMode = .scaleAspectFill
        view.alpha = 0.07
        return view
    }()

    private lazy var logoContainer = UIView()

    private lazy var logo = UIImageView(image: UIImage(asset: .TextLogo))

    private lazy var guestPassLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString(
            string: "30-day Guest Pass",
            attributes: [.kern : 0.48]
        )
        label.font = TextStyle.sublabel.font
        label.textColor = UIColor(color: Color.textPrimary)
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        label.attributedText = NSMutableAttributedString(
            string: "Give a friend unlimited access to Opal Pro,\n including unlimited schedules, app limits, deep\n focus, whitelisting and more!",
            attributes: [
                NSAttributedString.Key.kern: 0.07,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        label.textColor = UIColor(color: .textPrimary)
        label.font = TextStyle.paragraph.font
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let view = UIView()
        view.backgroundColor = UIColor(color: .mutedBackground)
        backgroundView = view

        contentView.addSubview(passBackground)
        passBackground.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(36)
        }

        passBackground.addSubview(seal)
        seal.snp.makeConstraints {
            $0.top.equalTo(-22)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(9)
        }

        passBackground.addSubview(logoContainer)
        logoContainer.snp.makeConstraints {
            $0.top.equalTo(63)
            $0.bottom.equalTo(-54)
            $0.centerX.equalToSuperview()
        }

        logoContainer.addSubview(logo)
        logo.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        logoContainer.addSubview(guestPassLabel)
        guestPassLabel.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(passBackground.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.lessThanOrEqualToSuperview().inset(16)
        }

        layoutIfNeeded()
    }

    func configure(theme: GemTheme) {
        self.colors = theme.colors
        layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        passBackground.layoutIfNeeded()
        passBackground.backgroundColor = UIColor(patternImage: UIImage.gradientImage(bounds: passBackground.bounds, colors: colors, alpha: 0.6))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
