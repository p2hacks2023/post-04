import ComposableArchitecture
import Models

@Reducer
public struct NewAchievementReducer {
    // MARK: - State
    public struct State: Equatable {
        var achievements: [Achievement]

        public init(achievement: Achievement) {
            self.achievements = [achievement]
        }

        public init(achievements: [Achievement]) {
            self.achievements = achievements
        }
    }

    // MARK: - Action
    public enum Action {
        case onOKButtonTapped
        case done
    }

    // MARK: - Dependencies

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onOKButtonTapped:
                state.achievements.removeFirst()
                if state.achievements.isEmpty {
                    return .send(.done)
                }
                return .none

            case .done:
                return .none
            }
        }
    }
}
