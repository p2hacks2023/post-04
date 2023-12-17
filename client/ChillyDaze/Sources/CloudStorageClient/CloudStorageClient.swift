import Foundation
import SwiftUI

public struct CloudStorageClient {
    public private(set) var uploadData: @Sendable(Data?, String) async throws -> String
    public private(set) var downloadData: @Sendable(String) async throws -> Data

    public init(
        uploadData: @escaping @Sendable(Data?, String) async throws -> String,
        downloadData: @escaping @Sendable(String) async throws -> Data
    ) {
        self.uploadData = uploadData
        self.downloadData = downloadData
    }
}
