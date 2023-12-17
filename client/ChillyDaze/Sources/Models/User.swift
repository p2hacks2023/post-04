import Foundation
import Gateway

public struct User: Identifiable, Equatable {
    // MARK: - Firebase Auth uid
    public let id: String
    public var name: String
    public let avatar: String?

    public init(
        id: String,
        name: String,
        avatar: String? = nil
    ) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }
}

public extension User {
    static func fromGateway(user: Gateway.UserQuery.Data.User) -> Self {
        .init(
            id: user.id,
            name: user.name,
            avatar: user.avatar?.name
        )
    }

    static func fromGateway(user: Gateway.RegisterUserMutation.Data.RegisterUser) -> Self {
        .init(
            id: user.id,
            name: user.name
        )
    }

    static func fromGateway(user: Gateway.UpdateUserMutation.Data.UpdateUser) -> Self {
        .init(
            id: user.id,
            name: user.name,
            avatar: user.avatar?.name
        )
    }
}

public extension User {
    static let sample0: Self = .init(
        id: UUID().uuidString,
        name: "John Due"
    )
}
