//
//  ClaimButton.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation
import UIKit

class ClaimButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 16
        titleLabel?.font = TextStyle.smallButton.font
        configureButton()
    }

    override var isEnabled: Bool {
        didSet {
            configureButton()
        }
    }

    private func configureButton() {
        if isEnabled {
            alpha = 1.0
            backgroundColor = .white
            setAttributedTitle(
                NSAttributedString(
                    string: "Claim",
                    attributes: [
                        .foregroundColor: UIColor.black,
                        .kern: 0.07
                    ]),
                for: .normal
            )
        } else {
            alpha = 0.5
            backgroundColor = UIColor.white.withAlphaComponent(0.1)
            let config = UIImage.SymbolConfiguration(
                pointSize: TextStyle.smallButton.font.pointSize,
                weight: .regular
            )
            setAttributedTitle(
                image: UIImage(
                    symbol: .checkmark,
                    configuration: config
                )?.withTintColor(UIColor.white.withAlphaComponent(0.4)) ?? UIImage(),
                text: "  Claimed",
                color: UIColor.white.withAlphaComponent(0.4),
                offset: -1
            )
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
