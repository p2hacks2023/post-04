import Dependencies
import Foundation

extension AuthClient: TestDependencyKey {
    public static let testValue: Self = .init(
        signInWithApple: unimplemented("\(Self.self)"),
        getCredentialStateOfSignInWithApple: unimplemented("\(Self.self)"),
        getCurrentUser: unimplemented("\(Self.self)"),
        signOut: unimplemented("\(Self.self)")
    )

    public static let previewValue = Self.testValue
}
