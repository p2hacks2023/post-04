import AuthClient
import ComposableArchitecture
import Models

@Reducer
public struct SettingsReducer {
    // MARK: - State
    public struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        var user: User

        public init(user: User) {
            self.user = user
        }
    }

    // MARK: - Action
    public enum Action {
        case alert(PresentationAction<Alert>)
        case onXButtonTapped
        case onAvatarTapped
        case onEditUsernameButtonTapped
        case onSignOutButtonTapped
        case signOutResult(Result<Void, Error>)
        case onDeleteAccountButtonTapped

        public enum Alert: Equatable {}
    }

    // MARK: - Dependencies
    @Dependency(\.authClient)
    private var authClient

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert:
                return .none

            case .onXButtonTapped:
                return .none

            case .onAvatarTapped:
                return .none

            case .onEditUsernameButtonTapped:
                return .none

            case .onSignOutButtonTapped:
                return .run { send in
                    await send(.signOutResult(Result {
                        try self.authClient.signOut()
                    }))
                }

            case .signOutResult(.success(_)):
                return .none

            case let .signOutResult(.failure(error)):
                state.alert = .init(title: .init(error.localizedDescription))
                return .none

            case .onDeleteAccountButtonTapped:
                return .none
            }
        }
    }
}
