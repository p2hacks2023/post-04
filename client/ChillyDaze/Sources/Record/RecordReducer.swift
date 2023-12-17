import ComposableArchitecture
import Foundation
import GatewayClient
import Models

@Reducer
public struct RecordReducer {
    // MARK: - State
    public struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        var chills: DataStatus<[Chill]>
        var chillsCount: Int {
            if case .loaded(let chills) = self.chills {
                let dict = Dictionary(grouping: chills.filter{ $0.photo != nil }) { chill in
                    Calendar.shared.startOfDay(for: chill.photo!.timestamp)
                }
                return dict.keys.count
            }
            return 0
        }
        var areaWeekPercent: Int {
            if case .loaded(let chills) = self.chills {
                let totalDistance = chills.map{ $0.distanceMeters }.reduce(0, +)
                return Int(totalDistance / (1000 * 7) * 100)
            }
            return 0
        }

        public init() {
            self.chills = .initialized
        }
    }

    // MARK: - Action
    public enum Action {
        case alert(PresentationAction<Alert>)
        case onAppear
        case onRefresh
        case getChillsResult(Result<[Chill], Error>)

        public enum Alert: Equatable {}
    }

    // MARK: - Dependencies
    @Dependency(\.gatewayClient)
    private var gatewayClient

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert:
                return .none

            case .onAppear:
                return .send(.onRefresh)

            case .onRefresh:
                state.chills = .loading
                return .run { send in
                    await send(.getChillsResult(Result {
                        try await self.gatewayClient.getChills()
                    }))
                }

            case let .getChillsResult(.success(chills)):
                state.chills = .loaded(chills.sorted(by: { e0, e1 in
                    if let t0 = e0.photo?.timestamp {
                        if let t1 = e1.photo?.timestamp {
                            return t0 > t1
                        }
                        return true
                    }

                    if let _ = e1.photo?.timestamp {
                        return false
                    }

                    return true
                }))
                return .none

            case let .getChillsResult(.failure(error)):
                state.alert = .init(title: .init(error.localizedDescription))
                state.chills = .initialized
                return .none
            }
        }
    }
}
