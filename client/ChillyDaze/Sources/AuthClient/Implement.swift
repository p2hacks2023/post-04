import AuthenticationServices
import FirebaseAuth
import KeychainSwift

enum Implement {
    static func signInWithApple(authResults: ASAuthorization) async throws -> FirebaseAuth.User {
        guard let appleIdCredential = authResults.credential as? ASAuthorizationAppleIDCredential else { throw AuthClientError.failedToGetASAuthorizationAppleIDCredential }
        guard let idToken = appleIdCredential.identityToken,
              let idTokenString = String(data: idToken, encoding: .utf8)
        else { throw AuthClientError.failedToGetASAuthorizationAppleIDCredentialIdToken }

        var firebaseAuthDataResult: AuthDataResult

        if let fullName = appleIdCredential.fullName {
            let credential = OAuthProvider.appleCredential(
                withIDToken: idTokenString,
                rawNonce: nil,
                fullName: fullName
            )

            firebaseAuthDataResult = try await Auth.auth().signIn(with: credential)
        } else {
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nil
            )

            guard let user = Auth.auth().currentUser else { throw AuthClientError.currentUserNotFound }

            firebaseAuthDataResult = try await user.reauthenticate(with: credential)
        }

        let user = firebaseAuthDataResult.user

        let firebaseIdToken = try await user.getIDToken()

        let keychain = KeychainSwift()
        keychain.set(firebaseIdToken, forKey: "idToken")

        return user
    }

    static func getCredentialStateOfSignInWithApple() async throws -> ASAuthorizationAppleIDProvider.CredentialState {
        guard let userID = Auth.auth().currentUser?.uid else { throw AuthClientError.currentUserNotFound }

        return try await withCheckedThrowingContinuation { continuation in
            let provider: ASAuthorizationAppleIDProvider = .init()
            provider.getCredentialState(forUserID: userID) { credentialState, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: credentialState)
            }
        }
    }
}
