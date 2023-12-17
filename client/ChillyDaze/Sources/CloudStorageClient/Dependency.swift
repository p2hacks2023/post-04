import Dependencies

public extension DependencyValues {
    var cloudStorageClient: CloudStorageClient {
        get { self[CloudStorageClient.self] }
        set { self[CloudStorageClient.self] = newValue }
    }
}
