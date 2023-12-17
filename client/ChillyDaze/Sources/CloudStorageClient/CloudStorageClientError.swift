import Foundation

public enum CloudStorageClientError: LocalizedError {
    case unauthenticated
    case failedToUpload
    case failedToDownload
    case dataIsEmpty

    public var errorDescription: String {
        switch self {
        case .unauthenticated:
            return "Unauthenticated"

        case .failedToUpload:
            return "Failed to upload data"

        case .failedToDownload:
            return "Failed to download data"

        case .dataIsEmpty:
            return "Data is empty"
        }
    }
}
