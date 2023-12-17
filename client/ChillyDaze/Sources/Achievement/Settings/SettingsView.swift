import ComposableArchitecture
import NukeUI
import Resources
import SwiftUI

struct SettingsView: View {
    typealias Reducer = SettingsReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    init(store: StoreOf<Reducer>) {
        Font.registerCustomFonts()
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 0) {
                Spacer()

                Button {
                    self.viewStore.send(.onXButtonTapped)
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.chillyWhite)
                        .padding(8)
                        .background(Color.chillyBlack)
                }
            }

            VStack(spacing: 72) {
                VStack(spacing: 30) {
                    Button {
                        self.viewStore.send(.onAvatarTapped)
                    } label: {
                        if let avatar = self.viewStore.user.avatar {
                            Image.Achievement.image(avatar)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 72, height: 72)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(Color.chillyBlack, style: StrokeStyle(lineWidth: 2))
                                }
                        } else {
                            Image.avatarDefault
                                .resizable()
                                .scaledToFit()
                                .frame(width: 72, height: 72)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(Color.chillyBlack, style: StrokeStyle(lineWidth: 2))
                                }
                        }
                    }

                    HStack(spacing: 10) {
                        Spacer()
                            .frame(width: 20)

                        Text(self.viewStore.user.name)
                            .font(Font.customFont(.inikaBold, size: 20))
                            .foregroundStyle(Color.chillyBlack)

                        Button {
                            self.viewStore.send(.onEditUsernameButtonTapped)
                        } label: {
                            Image(systemName: "pencil")
                                .font(.system(size: 20))
                                .foregroundStyle(Color.chillyBlack)
                        }
                    }
                }

                VStack(spacing: 24) {
                    Button {
                        self.viewStore.send(.onSignOutButtonTapped)
                    } label: {
                        Text("ログアウト")
                            .font(Font.customFont(.zenKakuGothicAntiqueMedium, size: 16))
                            .foregroundStyle(Color.chillyRed)
                    }

                    Button {
                        self.viewStore.send(.onDeleteAccountButtonTapped)
                    } label: {
                        Text("アカウント削除")
                            .font(Font.customFont(.zenKakuGothicAntiqueMedium, size: 16))
                            .foregroundStyle(Color.chillyBlack)
                    }
                }
            }

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.chillyWhite)
        .alert(store: self.store.scope(state: \.$alert, action: Reducer.Action.alert))
    }
}

#Preview {
    SettingsView(store: Store(initialState: SettingsView.Reducer.State(user: .sample0)) {
        SettingsView.Reducer()
    } withDependencies: {
        $0.authClient = .previewValue
    })
}
