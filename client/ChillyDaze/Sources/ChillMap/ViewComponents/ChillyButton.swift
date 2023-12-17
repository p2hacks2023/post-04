import Resources
import SwiftUI

struct ChillyButton: View {
    private var labelText: String?
    private var labelImage: String?
    private var foregroundColor: Color
    private var backgroundColor: Color
    private var borderColor: Color
    private var borderWidth: CGFloat
    private var action: () -> Void

    init(
        labelText: String? = nil,
        labelImage: String? = nil,
        foregroundColor: Color = .chillyBlack,
        backgroundColor: Color = .chillyYellow,
        borderColor: Color = .chillyBlack,
        borderWidth: CGFloat = 2,
        action: @escaping () -> Void
    ) {
        Font.registerCustomFonts()
        self.labelText = labelText
        self.labelImage = labelImage
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.action = action
    }

    var body: some View {
        Button(action: self.action) {
            HStack {
                if let labelText = self.labelText { Text(labelText) }

                if let labelImage = self.labelImage { Image(systemName: labelImage) }
            }
            .font(.customFont(.inikaBold, size: 20))
            .padding(.horizontal, self.labelText == nil ? 16 : 40)
            .foregroundStyle(self.foregroundColor).frame(height: 54)
            .background(self.backgroundColor).border(Color.chillyBlack, width: 2)
        }
    }
}

#Preview {
    VStack(spacing: 64) {
        ChillyButton(labelText: "Start", labelImage: "play.fill") {}

        HStack(spacing: 16.5) {
            ChillyButton(labelText: "Stop", labelImage: "stop.fill") {}

            ChillyButton(labelImage: "camera.fill") {}
        }

        HStack(spacing: 16.5) {
            ChillyButton(labelImage: "square.and.arrow.up") {}

            ChillyButton(
                labelText: "Ok",
                foregroundColor: .chillyWhite,
                backgroundColor: .chillyBlack
            ) {}
        }

        ChillyButton(labelText: "Ok") {}
    }
}
