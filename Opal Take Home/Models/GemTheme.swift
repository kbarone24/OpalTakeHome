//
//  GemTheme.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import UIKit

enum ThemeName {
    case opalDefault
    case loyal
    case soulful
    case pro
    case popular
    case special
    case mystery
}

struct GemTheme {
    let name: ThemeName
    let primaryColor: Color
    let secondaryColor: Color

    var colors: [UIColor] {
        [UIColor(color: primaryColor) ?? .black, UIColor(color: secondaryColor) ?? .blue]
    }

    init(name: ThemeName) {
        self.name = name

        switch name {
        case .opalDefault:
            primaryColor = Color.opalGreen
            secondaryColor = Color.opalBlue
        case .loyal:
            primaryColor = Color.opalBlue
            secondaryColor = Color.opalYellow
        case .soulful:
            primaryColor = Color.opalYellow
            secondaryColor = Color.opalGreen
        case .pro:
            primaryColor = Color.opalPurple
            secondaryColor = Color.opalBlue
        case .popular:
            primaryColor = Color.opalGreen
            secondaryColor = Color.opalPink
        case .special:
            primaryColor = Color.opalPink
            secondaryColor = Color.opalPurple
        case .mystery:
            primaryColor = Color.opalPurple
            secondaryColor = Color.opalOrange
        }
    }
}


extension GemTheme: Hashable {
    static func == (lhs: GemTheme, rhs: GemTheme) -> Bool {
        return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
