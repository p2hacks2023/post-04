import Resources
import SwiftUI

struct LaunchView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image.appIcon
                .resizable()
                .scaledToFit()
                .frame(width: 300)

            Image.chillyDaze
                .resizable()
                .scaledToFit()
                .frame(width: 300)

            Spacer()
                .frame(height: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.chillyWhite)
    }
}

#Preview {
    LaunchView()
}
