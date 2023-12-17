import Foundation

public enum AuthClientError: LocalizedError {
    case failedToGetASAuthorizationAppleIDCredential
    case failedToGetASAuthorizationAppleIDCredentialIdToken
    case failedToGetASAuthorizationAppleIDCredentialAdditionalInfo
    case currentUserNotFound

    public var errorDescription: String? {
        switch self {
        case .failedToGetASAuthorizationAppleIDCredential:
            return "Failed to get ASAuthorizationAppleIDCredential"

        case .failedToGetASAuthorizationAppleIDCredentialIdToken:
            return "Failed to get ASAuthorizationAppleIDCredential ID Token"

        case .failedToGetASAuthorizationAppleIDCredentialAdditionalInfo:
            return "Failed to get ASAuthorizationAppleIDCredential additional info"

        case .currentUserNotFound:
            return "Current firebase auth user was not found"
        }
    }
}
