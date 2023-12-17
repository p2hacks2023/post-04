import ComposableArchitecture
import Resources
import SwiftUI
import _AuthenticationServices_SwiftUI

public struct SignInView: View {
    public typealias Reducer = SignInReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    public var body: some View {
        VStack(spacing: 0) {
            Image.appIcon.resizable().scaledToFit().frame(width: 300)

            Image.readyToExploreChillyDaze.resizable().scaledToFit().frame(width: 300)

            Spacer().frame(height: 54)

            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                Task {
                    self.viewStore.send(
                        .signInWithAppleResult(
                            Result {
                                switch result {
                                case let .success(authResults): return authResults

                                case let .failure(error): throw error
                                }
                            }
                        )
                    )
                }
            }
            .signInWithAppleButtonStyle(.black).frame(width: 300, height: 48)

            Spacer().frame(height: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.chillyWhite)
        .alert(store: self.store.scope(state: \.$alert, action: Reducer.Action.alert))
    }
}

#Preview {
    SignInView(store: Store(initialState: SignInView.Reducer.State()) {
        SignInView.Reducer()
    })
}
