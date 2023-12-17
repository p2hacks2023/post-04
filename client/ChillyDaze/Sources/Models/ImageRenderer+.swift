import SwiftUI

public extension ImageRenderer {

    @MainActor
    static func getImage(content: Content) -> UIImage? where Content : View {
        let renderer = ImageRenderer(
            content: content
        )
        if let uiImage = renderer.uiImage {
            return uiImage
        }
        return nil
    }
}
