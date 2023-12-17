import Foundation
import Gateway

public struct AchievementCategory: Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let displayName: String

    init(
        id: UUID = .init(),
        name: String,
        displayName: String
    ) {
        self.id = id
        self.name = name
        self.displayName = displayName
    }
}

public extension AchievementCategory {
    static func fromGateway(category: Gateway.AchievementsQuery.Data.Achievement.Category) -> Self {
        .init(
            id: .init(uuidString: category.id) ?? .init(),
            name: category.name,
            displayName: category.displayName
        )
    }

    static func fromGateway(category: UserAchievementsQuery.Data.User.Achievement.Category) -> Self {
        .init(
            id: .init(uuidString: category.id) ?? .init(),
            name: category.name,
            displayName: category.displayName
        )
    }

    static func fromGateway(category: Gateway.EndChillMutation.Data.EndChill.NewAchievement.Category) -> Self {
        .init(
            id: .init(uuidString: category.id) ?? .init(),
            name: category.name,
            displayName: category.displayName
        )
    }

    static func fromGateway(category: Gateway.AchievementCategoriesQuery.Data.AchievementCategory) -> Self {
        .init(
            id: .init(uuidString: category.id) ?? .init(),
            name: category.name,
            displayName: category.displayName
        )
    }
}

public extension AchievementCategory {
    static let samples: [Self] = [
        .init(name: "area", displayName: "面積"),
        .init(name: "frequency", displayName: "回数"),
        .init(name: "continuous", displayName: "連続"),
    ]
}
