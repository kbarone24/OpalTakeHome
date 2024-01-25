//
//  Reward.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation
import UIKit

struct Reward {
    var id: String
    var referralCriteria: Int //     # of referrals to unlock
    var name: RewardName
    var description: String
    var claimed: Bool
    var isProUpgrade: Bool //        upgrade to pro reward only
    var theme: GemTheme

    var topReward = false
    var selectedReward = false

    init(id: String, referralCriteria: Int, name: RewardName, description: String, claimed: Bool, isProUpgrade: Bool, theme: GemTheme) {
        self.id = id
        self.referralCriteria = referralCriteria
        self.name = name
        self.description = description
        self.claimed = claimed
        self.isProUpgrade = isProUpgrade
        self.theme = theme
    }

    init() {
        self.id = ""
        self.referralCriteria = 0
        self.name = .LoyalGem
        self.description = ""
        self.claimed = false
        self.isProUpgrade = false
        self.theme = GemTheme(name: .opalDefault)
    }
}

extension Reward: Hashable {
    static func == (lhs: Reward, rhs: Reward) -> Bool {
        return lhs.id == rhs.id &&
        lhs.claimed == rhs.claimed &&
        lhs.topReward == rhs.topReward &&
        lhs.selectedReward == rhs.selectedReward
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(claimed)
        hasher.combine(topReward)
        hasher.combine(selectedReward)
    }
}

enum RewardName: String {
    case LoyalGem = "Loyal Gem"
    case SoulfulGem = "Soulful Gem"
    case ProUpgrade = "1 Year of Opal Pro"
    case PopularGem = "Popular Gem"
    case SpecialGift = "Special Gift"
    case MysteryGift = "Mystery Gift"

    var caseName: String {
        return String(describing: self)
    }
}

