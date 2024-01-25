//
//  GradientLabel.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation
import UIKit

class GradientLabel: UIStackView {
    var colors = [UIColor]()

    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    init(font: UIFont?) {
        super.init(frame: .zero)
        label.font = font
        setupView()
    }

    func configure(text: String, colors: [UIColor]) {
        self.colors = colors
        label.text = text
        layoutSubviews()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        axis = .vertical
        alignment = .center

        addArrangedSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let gradient = UIImage.gradientImage(bounds: label.bounds, colors: colors)
        label.textColor = UIColor(patternImage: gradient)
    }
}

// reference: https://nemecek.be/blog/143/always-correct-gradient-text-in-uikit
