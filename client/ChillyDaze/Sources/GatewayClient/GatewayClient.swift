import CoreLocation
import Foundation
import Models

public struct GatewayClient {
    public var registerUser: @Sendable (String) async throws -> User
    public var updateUser: @Sendable (String?, String?) async throws -> User

    public var getUser: @Sendable () async throws -> User
    public var getChills: @Sendable () async throws -> [Chill]
    public var getAchievements: @Sendable () async throws -> [Achievement]
    public var getUserAchievements: @Sendable () async throws -> [Achievement]
    public var getAchievementCategories: @Sendable () async throws -> [AchievementCategory]

    public var startChill: @Sendable (Date, Double, Double) async throws -> Chill
    public var endChill: @Sendable (String, [TracePoint], Photo?, CLLocationDistance, Date) async throws -> Chill

    public init(
        registerUser: @escaping @Sendable (String) async throws -> User,
        updateUser: @escaping @Sendable (String?, String?) async throws -> User,
        getUser: @escaping @Sendable () async throws -> User,
        getChills: @escaping @Sendable () async throws -> [Chill],
        getAchievements: @escaping @Sendable () async throws -> [Achievement],
        getUserAchievements: @escaping @Sendable () async throws -> [Achievement],
        getAchievementCategories: @escaping @Sendable () async throws -> [AchievementCategory],
        startChill: @escaping @Sendable (Date, Double, Double) async throws -> Chill,
        endChill: @escaping @Sendable (String, [TracePoint], Photo?, CLLocationDistance, Date) async throws -> Chill
    ) {
        self.registerUser = registerUser
        self.updateUser = updateUser
        self.getUser = getUser
        self.getChills = getChills
        self.getAchievements = getAchievements
        self.getUserAchievements = getUserAchievements
        self.startChill = startChill
        self.endChill = endChill
        self.getAchievementCategories = getAchievementCategories
    }
}
