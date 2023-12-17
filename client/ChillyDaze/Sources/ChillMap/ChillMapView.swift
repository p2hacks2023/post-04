import ComposableArchitecture
import MapKit
import Models
import Resources
import SwiftUI

public struct ChillMapView: View {
    public typealias Reducer = ChillMapReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        Font.registerCustomFonts()
        self.store = store
        self._viewStore = .init(
            wrappedValue: ViewStore(store, observe: { $0 })
        )
    }

    public var body: some View {
        SwitchStore(self.store.scope(state: \.scene, action: \.self)) { scene in
            switch scene {
            case .ready:
                ZStack {
                    Map(position: self.viewStore.$mapCameraPosition) {
                        UserAnnotation()

                        if case .loaded(let chills) = self.viewStore.chills {
                            ForEach(chills) { chill in
                                MapPolyline(coordinates: chill.traces.sorted(by: { $0.timestamp < $1.timestamp }).map {
                                    $0.coordinate
                                })
                                .stroke(
                                    Color.chillyBlue2,
                                    style: .init(
                                        lineWidth: 32,
                                        lineCap: .round,
                                        lineJoin: .round
                                    )
                                )
                            }
                        }
                    }

                    VStack(spacing: 0) {
                        Spacer()

                        ChillyButton(labelText: "Start", labelImage: "play.fill") {
                            self.viewStore.send(.onStartButtonTapped)
                        }

                        Spacer()
                            .frame(height: 22)
                    }

                    IfLetStore(self.store.scope(state: \.$newAchievement, action: \.newAchievement)) { store in
                        NewAchievementView(store: store)
                    }
                }
                .onAppear {
                    self.viewStore.send(.onAppear)
                }

            case .chillSession:
                CaseLet(/Reducer.State.Scene.chillSession, action: Reducer.Action.chillSession) { store in
                    ChillSessionView(store: store)
                }

            case .welcomeBack:
                CaseLet(/Reducer.State.Scene.welcomeBack, action: Reducer.Action.welcomeBack) { store in
                    WelcomeBackView(store: store)
                }
            }
        }
        .alert(store: self.store.scope(state: \.$alert, action: Reducer.Action.alert))
    }
}

#Preview {
    ChillMapView(store: Store(initialState: ChillMapView.Reducer.State()) {
        ChillMapView.Reducer()
    } withDependencies: {
        $0.cloudStorageClient = .previewValue
        $0.gatewayClient = .previewValue
        $0.locationManager = .previewValue
    })
}
