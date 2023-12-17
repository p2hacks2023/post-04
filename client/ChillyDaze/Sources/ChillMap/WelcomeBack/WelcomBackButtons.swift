import SwiftUI

struct WelcomBackButtons: View {
    private let image: UIImage
    private let chillRatePercent: Int
    private let action: () -> Void

    init(
        shareContent image: UIImage,
        chillRatePercent: Int,
        okAction action: @escaping () -> Void
    ) {
        self.image = image
        self.chillRatePercent = chillRatePercent
        self.action = action
    }

    var body: some View {
        HStack(spacing: 26) {
            ShareLink(
                item: Image(uiImage: image),
                subject: Text("Chill in Chilly Daze"),
                message: Text("I chilled \(self.chillRatePercent)%"),
                preview: .init(
                    "Chill in Chilly Daze\nI chilled \(self.chillRatePercent)%",
                    image: Image(uiImage: image)
                )
            ) {
                Image(systemName: "square.and.arrow.up")
                    .font(.customFont(.inikaBold, size: 20)).padding(.horizontal, 16)
                    .frame(height: 54).foregroundStyle(Color.chillyBlack)
                    .background(Color.chillyYellow).border(Color.chillyBlack, width: 2)
            }

            ChillyButton(
                labelText: "Ok",
                foregroundColor: .chillyWhite,
                backgroundColor: .chillyBlack
            ) {
                self.action()
            }
        }
    }
}

#Preview {
    WelcomBackButtons(
        shareContent: UIImage.appIcon,
        chillRatePercent: 67
    ) {}
}
