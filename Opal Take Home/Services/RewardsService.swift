//
//  RewardService.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/23/24.
//

import Foundation
import UIKit

protocol RewardsServiceProtocol {
    func fetchRewards(userProfile: UserProfile) async -> [Reward]
}

final class RewardsService: RewardsServiceProtocol {
    let mockDataSource: [Reward] = [
        Reward(id: UUID().uuidString, referralCriteria: 1, name: .LoyalGem, description: "Unlock this special milestone", claimed: false, isProUpgrade: false, theme: GemTheme(name: .loyal)),
        Reward(id: UUID().uuidString, referralCriteria: 3, name: .SoulfulGem, description: "Unlock this special milestone", claimed: false, isProUpgrade: false, theme: GemTheme(name: .soulful)),
        Reward(id: UUID().uuidString, referralCriteria: 5, name: .ProUpgrade, description: "Unlock one whole year of Opal Pro for Free", claimed: false, isProUpgrade: true, theme: GemTheme(name: .pro)),
        Reward(id: UUID().uuidString, referralCriteria: 10, name: .PopularGem, description: "Unlock this special milestone", claimed: false, isProUpgrade: false, theme: GemTheme(name: .popular)),
        Reward(id: UUID().uuidString, referralCriteria: 20, name: .SpecialGift, description: "Contact us to receive a special gift from the Opal Team", claimed: false, isProUpgrade: false, theme: GemTheme(name: .special)),
        Reward(id: UUID().uuidString, referralCriteria: 100, name: .MysteryGift, description: "Contact us to receive a special gift from the Opal Team", claimed: false, isProUpgrade: false, theme: GemTheme(name: .mystery))
    ]
    
    func fetchRewards(userProfile: UserProfile) async -> [Reward] {
        await withUnsafeContinuation { continuation in
            Task(priority: .high) {
                // mimic async database call
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    var filteredData = self.mockDataSource
                    if userProfile.proUser {
                        filteredData.removeAll(where: { $0.isProUpgrade })
                    }
                    continuation.resume(returning: filteredData)
                }
            }
        }
    }
}
