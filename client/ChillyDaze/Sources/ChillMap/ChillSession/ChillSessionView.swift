import Camera
import ComposableArchitecture
import MapKit
import Models
import SwiftUI

struct ChillSessionView: View {
    typealias Reducer = ChillSessionReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    var body: some View {
        ZStack {
            Map(position: self.viewStore.$mapCameraPosition) {
                UserAnnotation()

                ForEach(self.viewStore.chills) { chill in
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

                MapPolyline(coordinates: self.viewStore.chill.traces.sorted(by: { $0.timestamp < $1.timestamp }).map {
                    $0.coordinate
                })
                .stroke(
                    Color.chillyBlue3,
                    style: .init(
                        lineWidth: 32,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            }

            VStack(spacing: 0) {
                Spacer()

                HStack(spacing: 16.5) {
                    ChillyButton(
                        labelText: "Stop",
                        labelImage: "stop.fill",
                        foregroundColor: .chillyWhite,
                        backgroundColor: .chillyBlack
                    ) { self.viewStore.send(.onStopButtonTapped) }

                    ChillyButton(labelImage: "camera.fill") {
                        self.viewStore.send(.onCameraButtonTapped)
                    }
                }

                Spacer()
                    .frame(height: 22)
            }

            IfLetStore(self.store.scope(state: \.$chillyAlert, action: \.chillyAlert)) { store in
                ChillyAlertView(store: store)
            }
        }
        .fullScreenCover(store: self.store.scope(state: \.$camera, action: Reducer.Action.camera), content: { store in
            CameraView(store: store)
        })
        .onAppear {
            self.viewStore.send(.onAppear)
        }
    }
}

#Preview {
    ChillSessionView(store: Store(initialState: ChillSessionView.Reducer.State(
        chills: Chill.samples,
        chill: Chill.samples[0]
    )) {
        ChillSessionView.Reducer()
    } withDependencies: {
        $0.locationManager = .previewValue
    })
}

