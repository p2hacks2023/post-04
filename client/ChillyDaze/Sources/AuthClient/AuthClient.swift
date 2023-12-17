import FirebaseAuth
import AuthenticationServices
import Foundation

public struct AuthClient {
    public private(set) var signInWithApple: @Sendable (ASAuthorization) async throws -> User
    public private(set) var getCredentialStateOfSignInWithApple: @Sendable () async throws -> ASAuthorizationAppleIDProvider.CredentialState
    public private(set) var getCurrentUser: @Sendable () async throws -> User
    public private(set) var signOut: @Sendable() throws -> Void

    public init(
        signInWithApple: @escaping @Sendable (ASAuthorization) async throws -> User,
        getCredentialStateOfSignInWithApple: @escaping @Sendable () async throws -> ASAuthorizationAppleIDProvider.CredentialState,
        getCurrentUser: @escaping @Sendable () async throws -> User,
        signOut: @escaping @Sendable() throws -> Void
    ) {
        self.signInWithApple = signInWithApple
        self.getCredentialStateOfSignInWithApple = getCredentialStateOfSignInWithApple
        self.getCurrentUser = getCurrentUser
        self.signOut = signOut
    }
}
