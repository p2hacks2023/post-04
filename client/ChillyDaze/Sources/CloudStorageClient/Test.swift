import Dependencies
import Foundation
import Resources
import SwiftUI

extension CloudStorageClient: TestDependencyKey {
    public static let testValue: Self = .init(
        uploadData: { _, _ in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return ""
        },
        downloadData: { _ in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return Data()
        }
    )

    public static let previewValue = Self.testValue
}
