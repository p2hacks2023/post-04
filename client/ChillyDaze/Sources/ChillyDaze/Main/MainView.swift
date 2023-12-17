import Achievement
import ChillMap
import ComposableArchitecture
import Record
import SwiftUI

struct MainView: View {
    typealias Reducer = MainReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    init(store: StoreOf<Reducer>) {
        Font.registerCustomFonts()
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch self.viewStore.tab {
                case .chillMap:
                    ChillMapView(
                        store: self.store.scope(
                            state: \.chillMap,
                            action: \.chillMap
                        )
                    )

                case .record:
                    RecordView(
                        store: self.store.scope(
                            state: \.record,
                            action: \.record
                        )
                    )

                case .achievement:
                    AchievementView(
                        store: self.store.scope(
                            state: \.achievement,
                            action: \.achievement
                        )
                    )
                }
            }
            .frame(maxHeight: .infinity)

            TabBarView(store: self.store)
        }
    }
}

#Preview {
    MainView(store: Store(initialState: MainView.Reducer.State()) {
        MainView.Reducer()
    })
}
