import ComposableArchitecture

@Reducer
public struct ChillyAlertReducer {
    // MARK: - State
    public struct State: Equatable {
        var message: String
        var primaryButtonLabelText: String
        var secondaryButtonLabelText: String

        public init(
            message: String,
            primaryButtonLabelText: String,
            secondaryButtonLabelText: String = "キャンセル"
        ) {
            self.message = message
            self.primaryButtonLabelText = primaryButtonLabelText
            self.secondaryButtonLabelText = secondaryButtonLabelText
        }
    }

    // MARK: - Action
    public enum Action {
        case onPrimaryButtonTapped
        case onSecondaryButtonTapped
    }

    // MARK: - Dependencies

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onPrimaryButtonTapped:
                return .none

            case .onSecondaryButtonTapped:
                return .none
            }
        }
    }
}
