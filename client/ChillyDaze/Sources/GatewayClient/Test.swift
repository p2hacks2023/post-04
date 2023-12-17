import Dependencies
import Foundation
import Models

extension GatewayClient: TestDependencyKey {
    public static let testValue: Self = .init(
        registerUser: { _ in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return User.sample0
        },
        updateUser: { _, _ in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return User.sample0
        },
        getUser: {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return User.sample0
        },
        getChills: {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return Chill.samples
        },
        getAchievements: {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return Achievement.samples
        },
        getUserAchievements: {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return Achievement.userAchievementsSample
        },
        getAchievementCategories: {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return AchievementCategory.samples
        },
        startChill: { _, _, _ in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return Chill.samples[0]
        },
        endChill: { _, _, _, _, _ in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return Chill.samples[0]
        }
    )

    public static let previewValue = Self.testValue
}
