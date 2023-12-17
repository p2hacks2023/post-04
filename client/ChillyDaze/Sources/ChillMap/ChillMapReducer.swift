import ComposableArchitecture
import GatewayClient
import LocationManager
import _MapKit_SwiftUI
import Models
import SwiftUI

@Reducer
public struct ChillMapReducer {
    // MARK: - State
    public struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        var scene: Scene
        @PresentationState var newAchievement: NewAchievementReducer.State?
        @BindingState var mapCameraPosition: MapCameraPosition
        var chills: DataStatus<[Chill]>

        public init() {
            self.scene = .ready
            self.mapCameraPosition = .camera(
                .init(
                    centerCoordinate: .init(latitude: 0, longitude: 0),
                    distance: 3000
                )
            )
            self.chills = .initialized
        }

        @CasePathable
        enum Scene: Equatable {
            case ready
            case chillSession(ChillSessionReducer.State)
            case welcomeBack(WelcomeBackReducer.State)
        }
    }

    // MARK: - Action
    public enum Action: BindableAction {
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)

        case onAppear

        case getChillsResult(Result<[Chill], Error>)

        case onStartButtonTapped
        case startChillResult(Result<Chill, Error>)

        case chillSession(ChillSessionReducer.Action)
        case welcomeBack(WelcomeBackReducer.Action)
        case newAchievement(PresentationAction<NewAchievementReducer.Action>)

        public enum Alert: Equatable {}
    }

    // MARK: - Dependencies
    @Dependency(\.gatewayClient)
    private var gatewayClient
    @Dependency(\.locationManager)
    private var locationManager

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Scope(state: \.scene, action: \.self) {
            Scope(state: \.chillSession, action: \.chillSession) {
                ChillSessionReducer()
            }
            Scope(state: \.welcomeBack, action: \.welcomeBack) {
                WelcomeBackReducer()
            }
        }

        Reduce {
            state,
            action in
            switch action {
            case .alert:
                return .none

            case .binding:
                return .none

            case .onAppear:
                switch state.scene {
                case .ready:
                    do {
                        try self.locationManager.startUpdatingLocation()

                        let coordinate = try self.locationManager.getCurrentLocation()

                        state.mapCameraPosition = .camera(
                            .init(
                                centerCoordinate: coordinate,
                                distance: state.mapCameraPosition.camera?.distance ?? 3000
                            )
                        )
                    } catch {
                        state.alert = .init(title: .init(error.localizedDescription))
                        return .none
                    }

                    state.chills = .loading

                    return .run { send in
                            await send(.getChillsResult(Result {
                                try await self.gatewayClient.getChills()
                            }))
                        }

                default:
                    break
                }

                return .none

            case let .getChillsResult(.success(chills)):
                state.chills = .loaded(chills)
                return .none

            case let .getChillsResult(.failure(error)):
                state.alert = .init(title: .init(error.localizedDescription))
                state.chills = .initialized
                return .none

            

            case .onStartButtonTapped:
                return .run { send in
                    await send(
                        .startChillResult(Result {
                            let coordinate: CLLocationCoordinate2D = try self.locationManager.getCurrentLocation()

                            return try await self.gatewayClient.startChill(
                                .now,
                                coordinate.latitude,
                                coordinate.longitude
                            )
                        })
                    )
                }

            case let .startChillResult(.success(chill)):
                switch state.scene {
                case .ready:
                    self.locationManager.enableBackgroundMode()
                    switch state.chills {
                    case let .loaded(chills):
                        state.scene = .chillSession(.init(
                            chills: chills,
                            chill: chill
                        ))

                    default:
                        break
                    }

                default:
                    break
                }
                return .none

            case let .startChillResult(.failure(error)):
                state.alert = .init(title: .init(error.localizedDescription))
                return .none

            case var .chillSession(.onEndChill(chill)):
                do {
                    let coordinate: CLLocationCoordinate2D = try self.locationManager.getCurrentLocation()
                    let tracePoint: TracePoint = .init(timestamp: .now, coordinate: coordinate)
                    chill.traces.append(tracePoint)
                    self.locationManager.disableBackgroundMode()
                    state.scene = .welcomeBack(.init(chill: chill))
                } catch {
                    state.alert = .init(title: {
                        .init(error.localizedDescription)
                    })
                }
                return .none

            case let .welcomeBack(.savePhotoResult(.failure(error))):
                state.alert = .init(title: .init(error.localizedDescription))
                return .none

            case let .welcomeBack(.stopChillResult(.success(chill))):
                state.scene = .ready
                if let newAchievements = chill.newAchievements,
                   !newAchievements.isEmpty {
                    state.newAchievement = .init(achievements: newAchievements)
                }
                return .none

            case let .welcomeBack(.stopChillResult(.failure(error))):
                state.alert = .init(title: .init(error.localizedDescription))
                return .none

            case .newAchievement(.presented(.done)):
                state.newAchievement = nil
                return .none

            case .chillSession:
                return .none

            case .welcomeBack:
                return .none

            case .newAchievement:
                return .none
            }
        }
    }
}
