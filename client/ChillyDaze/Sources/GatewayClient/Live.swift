import Dependencies
import Foundation
import Models

extension GatewayClient: DependencyKey {
    public static let liveValue: Self = .init(
        registerUser: { name in
            try await Implement.registerUser(name: name)
        },
        updateUser: { name, avatar in
            try await Implement.updateUser(name: name, avatar: avatar)
        },
        getUser: {
            try await Implement.getUser()
        },
        getChills: {
            try await Implement.getChills()
        },
        getAchievements: {
            try await Implement.getAchievements()
        },
        getUserAchievements: {
            try await Implement.getUserAchievements()
        },
        getAchievementCategories: {
            try await Implement.getAchievementCategories()
        },
        startChill: {
            timestamp,
            latitude,
            longitude in

            try await Implement.startChill(
                timestamp: timestamp,
                latitude: latitude,
                longitude: longitude
            )
        },
        endChill: {
            id,
            tracePoints,
            photo,
            distanceMeters,
            timestamp in

            try await Implement.endChill(
                id: id,
                tracePoints: tracePoints,
                photo: photo,
                distanceMeters: distanceMeters,
                timestamp: timestamp
            )
        }
    )
}
