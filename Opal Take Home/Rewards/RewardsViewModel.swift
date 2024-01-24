//
//  RewardsViewModel.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/23/24.
//

import Foundation
import UIKit
import Combine

class RewardsViewModel {
    let rewardsService: RewardsServiceProtocol

    init(serviceContainer: ServiceContainer) {
        guard let rewardsService = try? serviceContainer.service(for: \.rewardsService) else {
            rewardsService = RewardsService()
            return
        }
        self.rewardsService = rewardsService
    }
}
