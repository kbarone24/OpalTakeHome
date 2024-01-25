//
//  UserProfile.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation
import UIKit

struct UserProfile {
    var id: String
    var username: String
    var referredFriendIDs: [String]
    var proUser: Bool
    var selectedTheme = GemTheme(name: .opalDefault)

    init(id: String, username: String, referredFriendIDs: [String], proUser: Bool) {
        self.id = id
        self.username = username
        self.referredFriendIDs = referredFriendIDs
        self.proUser = proUser
    }

    init(referralCount: Int, proUser: Bool) {
        // generate test user profile to test RewardsViewController
        self.proUser = proUser

        id = UUID().uuidString
        username = "Test user"

        var referredIDs = [String]()
        for _ in 0..<referralCount {
            referredIDs.append(UUID().uuidString)
        }
        self.referredFriendIDs = referredIDs
    }

    init() {
        id = UUID().uuidString
        username = "Test user"
        referredFriendIDs = []
        proUser = false
    }
}

extension UserProfile: Hashable {
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.id == rhs.id &&
        lhs.proUser == rhs.proUser &&
        lhs.selectedTheme.name == rhs.selectedTheme.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(proUser)
        hasher.combine(selectedTheme.name)
    }
}

