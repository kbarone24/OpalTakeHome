//
//  UserService.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUserProfile(referralCount: Int, proUser: Bool) async -> UserProfile
}

final class UserService: UserServiceProtocol {
    func fetchUserProfile(referralCount: Int, proUser: Bool) async -> UserProfile {
        await withUnsafeContinuation { continuation in
            Task(priority: .high) {
                // mimic async database call
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    continuation.resume(returning: UserProfile(referralCount: referralCount, proUser: proUser))
                }
            }
        }
    }
}
