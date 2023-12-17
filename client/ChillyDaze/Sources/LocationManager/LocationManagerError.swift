import Foundation

public enum LocationManagerError: LocalizedError {
    case failedToGetCoordinate
    case locationServiceIsNotPermitted

    public var errorDescription: String {
        switch self {
        case .failedToGetCoordinate:
            return "Failed to get coordinate."

        case .locationServiceIsNotPermitted:
            return "Location service is not permitted."
        }
    }
}
