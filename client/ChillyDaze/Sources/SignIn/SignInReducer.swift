import AuthClient
import AuthenticationServices
import ComposableArchitecture
import FirebaseAuth
import GatewayClient
import Models

@Reducer
public struct SignInReducer {
    // MARK: - State
    public struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        
        public init() {}
    }
    
    // MARK: - Action
    public enum Action {
        case alert(PresentationAction<Alert>)
        case firebaseAuthResult(Result<FirebaseAuth.User, Error>)
        case registerUserResult(Result<Models.User, Error>)
        case signInWithAppleResult(Result<ASAuthorization, Error>)

        public enum Alert: Equatable {}
    }
    
    // MARK: - Dependencies
    @Dependency(\.authClient)
    private var authClient
    @Dependency(\.gatewayClient)
    private var gatewayClient
    
    public init() {}
    
    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce {
            state,
            action in
            switch action {
            case .alert:
                return .none

            case let .firebaseAuthResult(.success(user)):
                return .run { send in
                    await send(
                        .registerUserResult(Result {
                            try await self.gatewayClient.registerUser(
                                user.displayName ?? ""
                            )
                        })
                    )
                }
                
            case let .firebaseAuthResult(.failure(error)):
                state.alert = .init(title: .init(error.localizedDescription))
                return .none
                
            case .registerUserResult(.success(_)):
                return .none
                
            case let .registerUserResult(.failure(error)):
                state.alert = .init(title: .init(error.localizedDescription))
                return .none
                
            case let .signInWithAppleResult(.success(authResults)):
                return .run { send in
                    await send(
                        .firebaseAuthResult(Result {
                            try await self.authClient.signInWithApple(authResults)
                        })
                    )
                }
                
            case let .signInWithAppleResult(.failure(error)):
                state.alert = .init(title: .init(error.localizedDescription))
                return .none
            }
        }
    }
}
