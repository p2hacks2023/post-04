import ComposableArchitecture
import SwiftUI

struct ChillyAlertView: View {
    typealias Reducer = ChillyAlertReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(self.viewStore.message).frame(height: 47)

            Rectangle().fill(Color.chillyBlack).frame(height: 2)

            HStack(spacing: 0) {
                Button {
                    self.viewStore.send(.onSecondaryButtonTapped)
                } label: {
                    Text(self.viewStore.secondaryButtonLabelText)
                }
                .frame(width: 147)

                Rectangle().fill(Color.chillyBlack).frame(width: 2)

                Button {
                    self.viewStore.send(.onPrimaryButtonTapped)
                } label: {
                    Text(self.viewStore.primaryButtonLabelText)
                        .font(.customFont(.zenKakuGothicAntiqueBlack, size: 17))
                }
                .frame(width: 147)
            }
            .frame(height: 47)
        }
        .font(.customFont(.zenKakuGothicAntiqueMedium, size: 17))
        .foregroundStyle(Color.chillyBlack)
        .background(Color.chillyWhite)
        .frame(width: 300, height: 100)
        .border(Color.chillyBlack, width: 2)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.chillyBackground)
    }
}

#Preview {
    ChillyAlertView(store: Store(
        initialState: ChillyAlertView.Reducer.State(
            message: "アクティビティを終了しますか？",
            primaryButtonLabelText: "終了"
        )
    ) {
        ChillyAlertView.Reducer()
    })
}
