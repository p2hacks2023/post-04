import ComposableArchitecture
import Models
import SwiftUI

struct WelcomeBackView: View {
    typealias Reducer = WelcomeBackReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    var body: some View {
        VStack(spacing: 62) {
            VStack(spacing: 32) {
                Image.welcomeBack.resizable().scaledToFit().frame(width: 265)

                ZStack {
                    VStack(spacing: 0) {
                        Rectangle().frame(height: 2)

                        WelcomeBackImageView(
                            uiImage: self.viewStore.currentImage,
                            chillRate: self.viewStore.chillRate
                        )

                        Rectangle().frame(height: 2)
                    }

                    if let shots = self.viewStore.shots,
                       shots.count > 1 {
                        HStack(spacing: 0) {
                            if self.viewStore.imageIndex > 0 {
                                Button {
                                    self.viewStore.send(.onPreviousButtonTapped)
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 22))
                                        .foregroundStyle(Color.chillyWhite)
                                        .padding(.vertical, 9)
                                        .padding(.horizontal, 14)
                                        .background(Color.chillyBlack)
                                }
                            }

                            Spacer()

                            if self.viewStore.imageIndex < shots.count - 1 {
                                Button {
                                    self.viewStore.send(.onNextButtonTapped)
                                } label: {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 22))
                                        .foregroundStyle(Color.chillyWhite)
                                        .padding(.vertical, 9)
                                        .padding(.horizontal, 14)
                                        .background(Color.chillyBlack)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }

            if let finalShot = self.viewStore.finalShot {
                WelcomBackButtons(
                    shareContent: finalShot.image,
                    chillRatePercent: self.viewStore.chillRatePercent
                ) {
                    self.viewStore.send(.onOkButtonTapped(finalShot))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.chillyWhite)
        .onAppear {
            self.viewStore.send(.onAppear)
        }
    }
}

#Preview {
    WelcomeBackView(store: Store(initialState: WelcomeBackView.Reducer.State(
        chill: .samples[0]
    )) {
        WelcomeBackView.Reducer()
    })
}
