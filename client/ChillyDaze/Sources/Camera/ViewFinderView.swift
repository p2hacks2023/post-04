import Models
import Resources
import SwiftUI

struct ViewFinderView: View {
    private let image: UIImage

    init(image: UIImage) {
        self.image = image
    }

    var body: some View {
        Image(uiImage: self.image)
            .resizable()
            .scaledToFill()
    }
}

#Preview {
    ViewFinderView(image: UIImage.appIcon)
}
