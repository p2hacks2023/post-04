import ComposableArchitecture
import NukeUI
import Resources
import SwiftUI

public struct AchievementView: View {
    public typealias Reducer = AchievementReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        Font.registerCustomFonts()
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()

                Button {
                    self.viewStore.send(.onSettingsButtonTapped)
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundStyle(Color.chillyBlack)
                        .font(.system(size: 24))
                }
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        switch self.viewStore.user {
                        case .initialized, .loading:
                            Circle()
                                .strokeBorder(
                                    Color.chillyBlack,
                                    style: StrokeStyle(lineWidth: 2)
                                )
                                .fill(Color.chillyWhite)
                                .frame(width: 72, height: 72)

                            Rectangle()
                                .fill(Color.chillyBlack)
                                .frame(width: 96, height: 28)

                        case let .loaded(user):
                            if let avatar = user.avatar {
                                Image.Achievement.image(avatar, isActive: true)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 72, height: 72)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .strokeBorder(
                                                Color.chillyBlack,
                                                style: StrokeStyle(lineWidth: 2)
                                            )
                                    }
                            } else {
                                Image.avatarDefault
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 72, height: 72)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle()
                                            .strokeBorder(Color.chillyBlack, style: StrokeStyle(lineWidth: 2))
                                    }
                            }

                            ZStack {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 96, height: 28)

                                Text(user.name)
                                    .font(Font.customFont(.inikaRegular, size: 20))
                                    .foregroundStyle(Color.chillyBlack)
                            }
                        }
                    }

                    Divider()
                        .frame(height: 2)
                        .background(Color.chillyBlack)

                    VStack(alignment: .leading, spacing: 24) {
                        switch (
                            self.viewStore.achievementCategories,
                            self.viewStore.achievements,
                            self.viewStore.userAchievements
                        ) {
                        case let (.loaded(categories), .loaded(achievements), .loaded(userAchievements)):
                            ForEach(categories) { category in
                                AchievementRow(
                                    category: category,
                                    achievements: achievements,
                                    userAchievements: userAchievements
                                )
                            }

                        case (.loading, .loading, .loading):
                            ProgressView()

                        default:
                            EmptyView()
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .refreshable {
                self.viewStore.send(.onRefresh)
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.chillyWhite)
        .onAppear {
            self.viewStore.send(.onAppear)
        }
        .alert(store: self.store.scope(state: \.$alert, action: Reducer.Action.alert))
        .fullScreenCover(store: self.store.scope(state: \.$settings, action: Reducer.Action.settings)) { store in
            SettingsView(store: store)
        }
    }
}

#Preview {
    AchievementView(store: Store(initialState: AchievementView.Reducer.State()) {
        AchievementView.Reducer()
    } withDependencies: {
        $0.gatewayClient = .previewValue
    })
}
