import Resources
import SwiftUI

struct ChillySignInWithAppleButton: View {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        Font.registerCustomFonts()
        self.action = action
    }

    var body: some View {
        Button(action: self.action) {
            HStack(spacing: 10) {
                Image(systemName: "applelogo")
                Text("Sign in with Apple").font(.customFont(.inikaRegular, size: 20))
            }
            .padding(.vertical, 14).padding(.horizontal, 40).foregroundStyle(Color.chillyWhite)
            .background(Color.chillyBlack)
        }
    }
}

#Preview { ChillySignInWithAppleButton {} }
