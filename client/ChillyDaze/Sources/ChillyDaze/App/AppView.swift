import ComposableArchitecture
import FirebaseCore
import Resources
import SignIn
import SwiftUI

public struct AppView: App {
    typealias Reducer = AppReducer
    private let store: StoreOf<Reducer>

    public init() {
        Font.registerCustomFonts()

        FirebaseApp.configure(
            options: .init(
                contentsOfFile: Bundle.module.path(
                    forResource: "GoogleService-Info",
                    ofType: "plist"
                )!
            )!
        )

        self.store = Store(initialState: .init()) {
            Reducer()
        }
    }

    public var body: some Scene {
        WindowGroup {
            SwitchStore(self.store) { state in
                switch state {
                case .launch:
                    LaunchView()
                        .onAppear {
                            self.store.send(.onAppear)
                        }

                case .signIn:
                    CaseLet(/Reducer.State.signIn, action: Reducer.Action.signIn) { store in
                        SignInView(store: store)
                    }

                case .main:
                    CaseLet(/Reducer.State.main, action: Reducer.Action.main) { store in
                        MainView(store: store)
                    }
                }
            }
            .font(.customFont(.inikaRegular, size: 20))
            .foregroundStyle(Color.chillyBlack)
            .background(Color.chillyWhite)
        }
    }
}
