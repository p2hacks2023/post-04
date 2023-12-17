import SwiftUI

public extension Font {
    enum CustomFonts: String, CaseIterable {
        case inikaBold = "Inika-Bold"
        case inikaRegular = "Inika"
        case zenKakuGothicAntiqueBlack = "ZenKakuGothicAntique-Black"
        case zenKakuGothicAntiqueBold = "ZenKakuGothicAntique-Bold"
        case zenKakuGothicAntiqueLight = "ZenKakuGothicAntique-Light"
        case zenKakuGothicAntiqueMedium = "ZenKakuGothicAntique-Medium"
        case zenKakuGothicAntiqueRegular = "ZenKakuGothicAntique-Regular"
    }

    static func customFont(_ customFont: CustomFonts, size: CGFloat) -> Font {
        .custom(
            customFont.rawValue,
            size: size
        )
    }

    static func registerCustomFonts() {
        CustomFonts.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "ttf")
        }
    }

    fileprivate static func registerFont(
        bundle: Bundle,
        fontName: String,
        fontExtension: String
    ) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider)
        else {
            fatalError("Could not create font from filename: \(fontName) with extension \(fontExtension)")
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
