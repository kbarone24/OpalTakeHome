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
    typealias Section = RewardsViewController.Section
    typealias Item = RewardsViewController.Item
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    struct Input {
        let refresh: PassthroughSubject<Bool, Never>
    }

    struct Output {
        let snapshot: AnyPublisher<Snapshot, Never>
    }

    let rewardsService: RewardsServiceProtocol
    let userService: UserServiceProtocol
    var referralCount: Int
    var proUser: Bool

    var cachedUserProfile: UserProfile?
    var cachedRewards: [Reward]?

    init(serviceContainer: ServiceContainer, referralCount: Int, proUser: Bool) {
        self.referralCount = referralCount
        self.proUser = proUser

        guard
            let rewardsService = try? serviceContainer.service(for: \.rewardsService),
            let userService = try? serviceContainer.service(for: \.userService)
        else {
            rewardsService = RewardsService()
            userService = UserService()
            return
        }
        self.rewardsService = rewardsService
        self.userService = userService
    }

    func bind(to input: Input) -> Output {
        let request = input.refresh
            .receive(on: DispatchQueue.global(qos: .background))
            .flatMap { [unowned self] refresh in
                (self.fetchRewardsData(refresh: refresh))
            }
            .map { $0 }

        let snapshot = request
            .receive(on: DispatchQueue.main)
            .map { userProfile, rewards, topReward in
                var snapshot = Snapshot()
                snapshot.appendSections([.topReward(gemTheme: userProfile.selectedTheme)])
                snapshot.appendItems([.topCell(reward: topReward, userProfile: userProfile)], toSection: .topReward(gemTheme: userProfile.selectedTheme))

                snapshot.appendSections([.main])
                _ = rewards.map {
                    snapshot.appendItems([.mainCell(reward: $0, userProfile: userProfile)], toSection: .main)
                }
                return snapshot
            }
            .eraseToAnyPublisher()

        return Output(snapshot: snapshot)
    }

    private func fetchRewardsData(refresh: Bool) ->
    AnyPublisher<(userProfile: UserProfile, rewards: [Reward], topReward: Reward), Never> {
        Deferred {
            Future { [weak self] promise in
                guard let self else {
                    promise(.success((userProfile: UserProfile(referralCount: 0, proUser: false), rewards: [], topReward: Reward())))
                    return
                }
                
                if let cachedUserProfile, var cachedRewards, !refresh {
                    // return cached values after user action
                    let topReward = self.getTopReward(
                        userProfile: cachedUserProfile,
                        rewards: cachedRewards
                    )
                    self.setSelectedReward(
                        selectedID: topReward.id,
                        rewards: &cachedRewards
                    )
                    promise(.success((
                        userProfile: cachedUserProfile,
                        rewards: cachedRewards,
                        topReward: topReward
                    )))
                    return
                }

                Task {
                    // run mock database fetch
                    let userProfile = await self.userService.fetchUserProfile(
                        referralCount: self.referralCount,
                        proUser: self.proUser
                    )
                    var rewards = await self.rewardsService.fetchRewards(userProfile: userProfile)

                    let topReward = self.getTopReward(
                        userProfile: userProfile,
                        rewards: rewards
                    )
                    self.setSelectedReward(
                        selectedID: topReward.id,
                        rewards: &rewards
                    )
                    promise(.success((
                        userProfile: userProfile,
                        rewards: rewards,
                        topReward: topReward
                    )))

                    self.cachedRewards = rewards
                    self.cachedUserProfile = userProfile
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func getTopReward(userProfile: UserProfile, rewards: [Reward]) -> Reward {
        var topReward: Reward?
        for reward in rewards {
            if userProfile.referredFriendIDs.count >= reward.referralCriteria &&
                !reward.claimed {
                // set to top reward that hasn't been claimed (rewards are pre-sorted)
                topReward = reward
            } else if topReward == nil {
                if !reward.claimed {
                    // set to next reward that user is making progress towards
                    topReward = reward
                } else if reward == rewards.last {
                    // set to the last reward if user has claimed all rewards
                    topReward = reward
                }
            }
        }
        topReward?.topReward = true
        return topReward ?? Reward()
    }

    private func setSelectedReward(selectedID: String, rewards: inout [Reward]) {
        // selectedReward toggles highlighted background in MainRewardCell
        for i in 0..<rewards.count {
            rewards[i].selectedReward = rewards[i].id == selectedID
        }
    }

    func updateClaimedRewards(rewardID: String) {
        if let i = cachedRewards?.firstIndex(where: { $0.id == rewardID }) {
            cachedRewards?[i].claimed = true
            cachedUserProfile?.selectedTheme = cachedRewards?[i].theme ?? GemTheme(name: .opalDefault)
        }
    }
}
