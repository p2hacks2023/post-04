import ComposableArchitecture
import Resources
import SwiftUI

struct TabBarView: View {
    typealias Reducer = MainReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(
            wrappedValue: ViewStore(store, observe: { $0 })
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 2)
                .background(Color.chillyBlack)

            HStack {
                Spacer()

                Button {
                    self.viewStore.send(.onTabButtonTapped(.chillMap))
                } label: {
                    if case .chillMap = self.viewStore.state.tab.self {
                        Image(systemName: "map.fill")
                    } else {
                        Image(systemName: "map")
                    }
                }

                Spacer()

                Button {
                    self.viewStore.send(.onTabButtonTapped(.record))
                } label: {
                    if case .record = self.viewStore.state.tab.self {
                        Image(systemName: "book.pages.fill")
                    } else {
                        Image(systemName: "book.pages")
                    }
                }

                Spacer()

                Button {
                    self.viewStore.send(.onTabButtonTapped(.achievement))
                } label: {
                    if case .achievement = self.viewStore.state.tab.self {
                        Image(systemName: "star.circle.fill")
                    } else {
                        Image(systemName: "star.circle")
                    }
                }

                Spacer()
            }
            .font(.system(size: 24))
            .foregroundStyle(Color.chillyBlack)
            .padding(.vertical, 19)
            .background(Color.chillyWhite)
        }
    }
}

#Preview {
    TabBarView(store: Store(initialState: TabBarView.Reducer.State()) {
        TabBarView.Reducer()
    })
}
