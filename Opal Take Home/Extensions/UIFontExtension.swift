//
//  UIFontExtension.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/23/24.
//

import Foundation
import UIKit

extension UIFont {
    enum CustomFont: String {
        case SFProBold = "SFProText-Bold"
        case SFProMedium = "SFProText-Medium"
    }

    convenience init?(_ name: CustomFont, size: CGFloat) {
        self.init(name: name.rawValue, size: size)
    }
}
