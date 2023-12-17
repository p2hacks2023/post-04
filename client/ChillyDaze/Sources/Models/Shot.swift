import Foundation
import Resources
import SwiftUI

public struct Shot: Equatable {
    public let id: UUID
    public let timestamp: Date
    public let image: UIImage

    public init(
        id: UUID = .init(),
        timestamp: Date,
        image: UIImage
    ) {
        self.id = id
        self.timestamp = timestamp
        self.image = image
    }
}

public extension Shot {
    static let samples: [Self] = [
        .init(
            timestamp: Formatter.iso8601.date(from: "2023-12-01T09:00:00+09")!,
            image: UIImage.appIcon
        ),
        .init(
            timestamp: Formatter.iso8601.date(from: "2023-12-01T09:00:01+09")!,
            image: UIImage.appIcon
        ),
        .init(
            timestamp: Formatter.iso8601.date(from: "2023-12-01T09:00:02+09")!,
            image: UIImage.appIcon
        ),
    ]
}
