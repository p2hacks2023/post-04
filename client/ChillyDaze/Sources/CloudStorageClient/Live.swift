import Dependencies
import Foundation

extension CloudStorageClient: DependencyKey {
    public static let liveValue: Self = .init(
        uploadData: { data, filename in
            try await Implement.uploadFile(data: data, filename: filename)
        },
        downloadData: { url in
            try await Implement.downloadFile(url: url)
        }
    )
}
