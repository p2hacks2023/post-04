import AuthenticationServices
import Dependencies
import FirebaseAuth
import Foundation
import KeychainSwift

extension AuthClient: DependencyKey {
    public static let liveValue: Self = .init(
        signInWithApple: { authResults in
            try await Implement.signInWithApple(authResults: authResults)
        },
        getCredentialStateOfSignInWithApple: {
            try await Implement.getCredentialStateOfSignInWithApple()
        },
        getCurrentUser: {
            guard let user = Auth.auth().currentUser else { throw AuthClientError.currentUserNotFound }

            let idToken = try await user.getIDToken()

            let keychain = KeychainSwift()
            keychain.set(idToken, forKey: "idToken")

            return user
        },
        signOut: {
            let keychain = KeychainSwift()
            keychain.clear()

            try Auth.auth().signOut()
        }
    )
}
