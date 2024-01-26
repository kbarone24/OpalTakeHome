//
//  Font.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation
import UIKit

enum Font: String {
    case opalRegular = "SFProDisplay-Regular"
    case opalSemibold = "SFProDisplay-Semibold"
    case opalMedium = "SFProDisplay-Medium"

    var name: String {
        return self.rawValue
    }
}

struct CustomFont {
    let font: Font
    let size: CGFloat
    let style: UIFont.TextStyle
}

enum TextStyle {
    case header
    case topRewardHeader
    case subheader
    case paragraph
    case mutedParagraph
    case sublabel
    case largeButton
    case smallButton
}

extension TextStyle {
    private var customFont: CustomFont {
        switch self {
        case .header:
            return CustomFont(font: .opalSemibold, size: 17, style: .headline)
        case .topRewardHeader:
            return CustomFont(font: .opalSemibold, size: 16, style: .headline)
        case .subheader:
            return CustomFont(font: .opalSemibold, size: 13, style: .subheadline)
        case .paragraph:
            return CustomFont(font: .opalRegular, size: 16, style: .body)
        case .mutedParagraph:
            return CustomFont(font: .opalRegular, size: 13, style: .body)
        case .sublabel:
            return CustomFont(font: .opalRegular, size: 12, style: .body)
        case .largeButton:
            return CustomFont(font: .opalRegular, size: 17, style: .callout)
        case .smallButton:
            return CustomFont(font: .opalRegular, size: 13, style: .callout)
        }
    }
}

extension TextStyle {
    var font: UIFont {
        guard let font = UIFont(name: customFont.font.name, size: customFont.size) else {
            return UIFont.preferredFont(forTextStyle: customFont.style)
        }

        let fontMetrics = UIFontMetrics(forTextStyle: customFont.style)
        return fontMetrics.scaledFont(for: font)
    }
}

// reference: https://www.ramshandilya.com/blog/design-system-typography/
