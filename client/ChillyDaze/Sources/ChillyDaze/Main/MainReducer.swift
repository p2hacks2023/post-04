import Achievement
import ChillMap
import ComposableArchitecture
import Record

@Reducer
struct MainReducer {
    // MARK: - State
    struct State: Equatable {
        var chillMap: ChillMapReducer.State
        var record: RecordReducer.State
        var achievement: AchievementReducer.State

        var tab: Tab

        init() {
            self.chillMap = .init()
            self.record = .init()
            self.achievement = .init()

            self.tab = .chillMap
        }

        enum Tab: Equatable {
            case chillMap
            case record
            case achievement
        }
    }

    // MARK: - Action
    enum Action {
        case onTabButtonTapped(State.Tab)

        case chillMap(ChillMapReducer.Action)
        case record(RecordReducer.Action)
        case achievement(AchievementReducer.Action)
    }

    // MARK: - Dependencies

    init() {}

    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Scope(state: \.chillMap, action: \.chillMap) {
            ChillMapReducer()
        }
        Scope(state: \.record, action: \.record) {
            RecordReducer()
        }
        Scope(state: \.achievement, action: \.achievement) {
            AchievementReducer()
        }

        Reduce { state, action in
            switch action {
            case let .onTabButtonTapped(newTab):
                state.tab = newTab
                return .none

            case .record:
                return .none

            case .chillMap:
                return .none

            case .achievement:
                return .none
            }
        }
    }
}
