import ComposableArchitecture
import NukeUI
import Resources
import SwiftUI

public struct RecordView: View {
    public typealias Reducer = RecordReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        Font.registerCustomFonts()
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                VStack(spacing: 10) {
                    ZStack {
                        Image.Banner.frequence
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width - 48)

                        if case .loaded(let chills) = self.viewStore.chills {
                            HStack(alignment: .bottom, spacing: 0) {
                                Spacer()
                                    .frame(width: 96)

                                Text("\(self.viewStore.chillsCount)")
                                    .font(.customFont(.inikaRegular, size: 102))

                                VStack(spacing: 0) {
                                    Text("/7")
                                        .font(.customFont(.inikaRegular, size: 30))

                                    Spacer()
                                        .frame(height: 12)
                                }
                            }
                            .padding(.top, -20)
                        }
                    }
                    .foregroundStyle(Color.chillyBlack)

                    ZStack {
                        Image.Banner.area
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width - 48)

                        if case .loaded(_) = self.viewStore.chills {
                            HStack(alignment: .bottom, spacing: 0) {
                                Spacer()
                                    .frame(width: 96)

                                Text("\(self.viewStore.areaWeekPercent)")
                                    .font(.customFont(.inikaRegular, size: 60))

                                VStack(spacing: 0) {
                                    Text("%")
                                        .font(.customFont(.inikaRegular, size: 30))

                                    Spacer()
                                        .frame(height: 8)
                                }
                            }
                        }
                    }
                    .foregroundStyle(Color.chillyBlack)
                }

                if case .loaded(let chills) = self.viewStore.chills {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                        ForEach(chills) { chill in
                            Group {
                                if let photo = chill.photo {
                                    LazyImage(url: URL(string: photo.url)) { state in
                                        if let image = state.image {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        } else if state.error != nil {
                                            Image.appIcon
                                                .resizable()
                                                .scaledToFit()
                                        } else {
                                            Image.appIcon
                                                .resizable()
                                                .scaledToFit()
                                        }
                                    }
                                } else {
                                    Image.appIcon
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            .frame(
                                width: (UIScreen.main.bounds.width - 48 - 10) / 2,
                                height: (UIScreen.main.bounds.width - 48 - 10) / 2
                            )
                            .border(Color.chillyBlack, width: 2)
                        }
                    }
                }
            }
        }
        .refreshable {
            self.viewStore.send(.onRefresh)
        }
        .padding(.top, 24)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.chillyWhite)
        .alert(store: self.store.scope(state: \.$alert, action: Reducer.Action.alert))
        .onAppear {
            self.viewStore.send(.onAppear)
        }
    }
}

#Preview {
    RecordView(store: Store(initialState: RecordView.Reducer.State()) {
        RecordView.Reducer()
    })
}
