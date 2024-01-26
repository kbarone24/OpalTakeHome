//
//  UIImageExtension.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/23/24.
//

import Foundation
import UIKit

extension UIImage {
    enum Asset: String {
        case LaunchLogo
        case LoyalGem
        case MysteryGift
        case PopularGem
        case ProUpgrade
        case SoulfulGem
        case SpecialGift
        case SealWhite
        case TextLogo
        case Handle
    }

    enum SFSymbol: String {
        case person = "person.fill"
        case addPerson = "person.crop.circle.badge.plus"
        case sendArrow = "square.and.arrow.up"
        case checkmark
        case downArrow = "arrow.down"
    }

    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }

    convenience init?(symbol: SFSymbol, configuration: Configuration?) {
        self.init(systemName: symbol.rawValue, withConfiguration: configuration)
    }
}

extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [UIColor], alpha: CGFloat = 1.0) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.withAlphaComponent(alpha).cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let renderer = UIGraphicsImageRenderer(bounds: bounds)

        return renderer.image { context in
            gradientLayer.render(in: context.cgContext)
        }
    }
}
// reference: https://medium.com/academy-poa/how-to-create-a-uiprogressview-with-gradient-progress-in-swift-2d1fa7d26f24
