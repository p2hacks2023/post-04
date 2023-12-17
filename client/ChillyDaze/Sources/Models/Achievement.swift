import Foundation
import Gateway

public struct Achievement: Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let displayName: String
    public let description: String
    public let category: AchievementCategory

    public init(
        id: UUID = .init(),
        name: String,
        displayName: String,
        description: String,
        category: AchievementCategory
    ) {
        self.id = id
        self.name = name
        self.displayName = displayName
        self.description = description
        self.category = category
    }
}

public extension Achievement {
    static func fromGateway(achievement: Gateway.AchievementsQuery.Data.Achievement) -> Self {
        let category: AchievementCategory = .fromGateway(category: achievement.category)

        return .init(
            id: .init(uuidString: achievement.id) ?? .init(),
            name: achievement.name,
            displayName: achievement.displayName,
            description: achievement.description,
            category: category
        )
    }

    static func fromGateway(achievement: Gateway.UserAchievementsQuery.Data.User.Achievement) -> Self {
        let category: AchievementCategory = .fromGateway(category: achievement.category)

        return .init(
            id: .init(uuidString: achievement.id) ?? .init(),
            name: achievement.name,
            displayName: achievement.displayName,
            description: achievement.description,
            category: category
        )
    }

    static func fromGateway(achievement: Gateway.EndChillMutation.Data.EndChill.NewAchievement) -> Self {
        let category: AchievementCategory = .fromGateway(category: achievement.category)

        return .init(
            id: .init(uuidString: achievement.id) ?? .init(),
            name: achievement.name,
            displayName: achievement.displayName,
            description: achievement.description,
            category: category
        )
    }
}

public extension Achievement {
    static let samples: [Self] = [
        .init(
            name: "area1",
            displayName: "色水",
            description: "1日で近所の新しい景色を見た",
            category: .samples[0]
        ),
        .init(
            name: "area2",
            displayName: "ハケ",
            description: "1週間で町のまだ見ぬ景色をみた",
            category: .samples[0]
        ),
        .init(
            name: "area3",
            displayName: "世界",
            description: "1週間で少し遠くの新しい景色をみた",
            category: .samples[0]
        ),
        .init(
            name: "frequency1",
            displayName: "ケーキ",
            description: "はじめての記録",
            category: .samples[1]
        ),
        .init(
            name: "frequency2",
            displayName: "リュック",
            description: "3回記録した",
            category: .samples[1]
        ),
        .init(
            name: "frequency3",
            displayName: "写真",
            description: "7回記録した",
            category: .samples[1]
        ),
        .init(
            name: "continuous1",
            displayName: "星1つ",
            description: "連続3日記録した",
            category: .samples[2]
        ),
        .init(
            name: "continuous2",
            displayName: "星2つ",
            description: "連続7日記録した",
            category: .samples[2]
        ),
        .init(
            name: "continuous3",
            displayName: "星3つ",
            description: "連続20日記録した",
            category: .samples[2]
        ),
    ]

    static let userAchievementsSample: [Self] = [
        .samples[0],
        .samples[1],
        .samples[3],
    ]
}
