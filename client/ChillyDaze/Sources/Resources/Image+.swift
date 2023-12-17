import SwiftUI

public extension Image {
    static let appIcon: Self = .init(.appIcon)
    static let avatarDefault: Self = .init(.avatarDefault)
    static let chillyDaze: Self = .init(.chillyDaze)
    static let iChilled: Self = .init(.iChilled)
    static let indicatorPin: Self = .init(.indicatorPin)
    static let readyToExploreChillyDaze: Self = .init(.readyToExploreChillyDaze)
    static let shutterButton: Self = .init(.shutterButton)
    static let welcomeBack: Self = .init(.welcomeBack)

    enum Achievement {}
    enum Banner {}
}

public extension Image.Achievement {
    static let achievementDefault: Image = .init(.Achievement.achievementDefault)

    static let area10: Image = .init(.Achievement.area10)
    static let area11: Image = .init(.Achievement.area11)
    static let area20: Image = .init(.Achievement.area20)
    static let area21: Image = .init(.Achievement.area21)
    static let area30: Image = .init(.Achievement.area30)
    static let area31: Image = .init(.Achievement.area31)
    static let frequence10: Image = .init(.Achievement.frequence10)
    static let frequence11: Image = .init(.Achievement.frequence11)
    static let frequence20: Image = .init(.Achievement.frequence20)
    static let frequence21: Image = .init(.Achievement.frequence21)
    static let frequence30: Image = .init(.Achievement.frequence30)
    static let frequence31: Image = .init(.Achievement.frequence31)
    static let continuous10: Image = .init(.Achievement.continuous10)
    static let continuous11: Image = .init(.Achievement.continuous11)
    static let continuous20: Image = .init(.Achievement.continuous20)
    static let continuous21: Image = .init(.Achievement.continuous21)
    static let continuous30: Image = .init(.Achievement.continuous30)
    static let continuous31: Image = .init(.Achievement.continuous31)

    static func image(_ from: String, isActive: Bool = false) -> Image {
        switch from {
        case "area1":
            return isActive ? area11 : area10

        case "area2":
            return isActive ? area21 : area20

        case "area3":
            return isActive ? area31 : area30

        case "frequence1":
            return isActive ? frequence11 : frequence10

        case "frequence2":
            return isActive ? frequence21 : frequence20

        case "frequence3":
            return isActive ? frequence31 : frequence30

        case "continuous1":
            return isActive ? continuous11 : continuous10

        case "continuous2":
            return isActive ? continuous21 : continuous20

        case "continuous3":
            return isActive ? continuous31 : continuous30

        default:
            return self.achievementDefault
        }
    }
}

public extension Image.Banner {
    static let area: Image = .init(.Banner.area)
    static let frequence: Image = .init(.Banner.frequence)
}
