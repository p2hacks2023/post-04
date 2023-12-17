import Resources
import SwiftUI

struct ChillyIndicator: View {
    private var chillRate: CGFloat

    init(chillRate: CGFloat) {
        Font.registerCustomFonts()
        self.chillRate = chillRate
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    Rectangle().fill(Color.chillyBlue).frame(width: geometry.size.width * chillRate)

                    Rectangle().fill(Color.chillyYellow)
                        .frame(width: geometry.size.width * (1 - chillRate))
                }
                .frame(height: 42).border(Color.chillyBlack, width: 2)

                ZStack {
                    Image.indicatorPin.resizable().scaledToFit().frame(height: 50)

                    Text("\(Int(chillRate * 100))%").font(.customFont(.inikaRegular, size: 18))
                        .foregroundStyle(Color.chillyWhite)
                }
                .offset(x: geometry.size.width * (self.chillRate - 0.5))
            }
        }
        .frame(maxHeight: 50)
    }
}

#Preview {
    VStack {
        ChillyIndicator(chillRate: 0)

        ChillyIndicator(chillRate: 0.03)

        ChillyIndicator(chillRate: 0.23)

        ChillyIndicator(chillRate: 0.43)

        ChillyIndicator(chillRate: 0.50)

        ChillyIndicator(chillRate: 0.67)

        ChillyIndicator(chillRate: 0.88)

        ChillyIndicator(chillRate: 0.98)

        ChillyIndicator(chillRate: 1)
    }
    .frame(width: 252)
}
