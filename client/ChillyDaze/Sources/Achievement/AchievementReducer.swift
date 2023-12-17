import ComposableArchitecture
import GatewayClient
import Models

@Reducer
public struct AchievementReducer {
    // MARK: - State
    public struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        @PresentationState var settings: SettingsReducer.State?
        var user: DataStatus<User>
        var achievementCategories: DataStatus<[AchievementCategory]>
        var achievements: DataStatus<[Achievement]>
        var userAchievements: DataStatus<[Achievement]>

        public init() {
            self.user = .initialized
            self.achievementCategories = .initialized
            self.achievements = .initialized
            self.userAchievements = .initialized
        }
    }

    // MARK: - Action
    public enum Action {
        case alert(PresentationAction<Alert>)
        case onAppear
        case onRefresh
        case userResult(Result<User, Error>)
        case achievementCategoriesResult(Result<[AchievementCategory], Error>)
        case achievementsResult(Result<[Achievement], Error>)
        case userAchievementsResult(Result<[Achievement], Error>)
        case onSettingsButtonTapped
        case settings(PresentationAction<SettingsReducer.Action>)

        public enum Alert: Equatable {}
    }

    // MARK: - Dependencies
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
                
            case .onAppear:
                return .send(.onRefresh)

            case .onRefresh:
                state.user = .loading
                state.achievementCategories = .loading
                state.achievements = .loading
                state.userAchievements = .loading

                return .merge (
                    .run { send in
                        await send(
                            .userResult(Result {
                                try await self.gatewayClient.getUser()
                            })
                        )
                    },
                    .run { send in
                        await send(
                            .achievementCategoriesResult(Result {
                                try await self.gatewayClient.getAchievementCategories()
                            })
                        )
                    },
                    .run { send in
                        await send(
                            .achievementsResult(Result {
                                try await self.gatewayClient.getAchievements()
                            })
                        )
                    },
                    .run { send in
                        await send(
                            .userAchievementsResult(Result {
                                try await self.gatewayClient.getUserAchievements()
                            })
                        )
                    }
                )

            case let .userResult(.success(user)):
                state.user = .loaded(user)
                return .none

            case let .userResult(.failure(error)):
                state.alert = .init(title: .init(error.localizedDescription))
                state.user = .initialized
                return .none

            case let .achievementCategoriesResult(.success(achievementCategories)):
                state.achievementCategories = .loaded(achievementCategories)
                return .none

            case let .achievementCategoriesResult(.failure(error)):
                state.alert = .init(title: .init(error.localizedDescription))
                state.achievementCategories = .initialized
                return .none

            case let .achievementsResult(.success(achievements)):
                state.achievements = .loaded(achievements)
                return .none

            case let .achievementsResult(.failure(error)):
                state.alert = .init(title: .init(error.localizedDescription))
                state.achievements = .initialized
                return .none

            case let .userAchievementsResult(.success(userAchievements)):
                state.userAchievements = .loaded(userAchievements)
                return .none

            case let .userAchievementsResult(.failure(error)):
                state.alert = .init(title: .init(error.localizedDescription))
                state.userAchievements = .initialized
                return .none

            case .onSettingsButtonTapped:
                switch state.user {
                case let .loaded(user):
                    state.settings = .init(user: user)

                default:
                    state.alert = .init(title: .init("Failed to load user."))
                }

                return .none

            case .settings(.presented(.onXButtonTapped)):
                state.settings = nil
                return .none

            case .settings:
                return .none
            }
        }
        .ifLet(\.$settings, action: /Action.settings) {
            SettingsReducer()
        }
    }
}
