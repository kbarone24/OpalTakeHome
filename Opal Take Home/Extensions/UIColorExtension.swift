//
//  ColorExtension.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/23/24.
//

import Foundation
import UIKit

enum Color: String {
    case accent = "AccentColor"
}

extension UIColor {
    convenience init?(color: Color) {
        self.init(named: color.rawValue)
    }
}