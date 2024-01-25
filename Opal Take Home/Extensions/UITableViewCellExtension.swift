//
//  UITableViewCellExtension.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import UIKit

extension UITableViewCell {
    static var reuseID: String {
        "\(Self.self)"
    }
}

extension UITableViewHeaderFooterView {
    static var reuseID: String {
        "\(Self.self)"
    }
}
