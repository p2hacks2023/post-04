import Foundation

public enum GatewayClientError: LocalizedError {
    case failedToFetchData

    public var errorDescription: String {
        switch self {
        case .failedToFetchData:
            return "Failed to fetch data."
        }
    }
}
