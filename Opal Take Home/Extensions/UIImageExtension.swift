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
    }

    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}
