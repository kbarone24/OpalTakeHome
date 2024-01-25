//
//  GradientProgressView.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation
import UIKit

class GradientProgressView: UIProgressView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 3
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var colors: [UIColor] = [] {
        didSet {
            updateView()
        }
    }

    func updateView() {
        let gradientImage = UIImage.gradientImage(bounds: self.bounds, colors: colors)
        self.progressImage = gradientImage
    }
}
