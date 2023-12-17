import Models
import SwiftUI

struct WelcomeBackImageView: View {
    private let image: Image?
    private let chillRate: CGFloat
    
    init(
        image: Image?,
        chillRate: CGFloat
    ) {
        self.image = image
        self.chillRate = chillRate
    }
    
    init(
        uiImage: UIImage?,
        chillRate: CGFloat
    ) {
        if let image = uiImage {
            self.image = Image(uiImage: image)
        } else {
            self.image = nil
        }
        self.chillRate = chillRate
    }
    
    var body: some View {
        Group {
            if let image = image {
                ZStack {
                    image.resizable()
                        .scaledToFill()
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.width
                        )
                        .clipped()
                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        ChillyIndicator(chillRate: chillRate)
                            .frame(width: 252)
                        
                        Spacer().frame(height: 22)
                    }
                }
            }
            else {
                VStack(alignment: .leading, spacing: 28) {
                    Image.iChilled.resizable().scaledToFit().frame(width: 140)
                    
                    ChillyIndicator(chillRate: chillRate)
                }
                .frame(width: 252)
            }
        }
        .frame(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.width
        )
        .background(Color.chillyWhite)
    }
}

#Preview {
    WelcomeBackImageView(
        image: nil,
        chillRate: 0.67
    )
}
