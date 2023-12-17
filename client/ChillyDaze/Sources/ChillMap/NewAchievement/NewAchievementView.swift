import ComposableArchitecture
import SwiftUI

struct NewAchievementView: View {
    typealias Reducer = NewAchievementReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    init(store: StoreOf<Reducer>) {
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    var body: some View {
        if let achievement = self.viewStore.achievements.first {
            VStack(spacing: 16) {
                Text(achievement.description)
                    .font(.customFont(.zenKakuGothicAntiqueMedium, size: 20))
                
                VStack(spacing: 32) {
                    Image.Achievement.image(achievement.name, isActive: true).resizable()
                        .scaledToFit().frame(width: 208)
                    
                    ChillyButton(labelText: "Ok") {
                        self.viewStore.send(.onOKButtonTapped)
                    }
                }
            }
            .padding(32).frame(width: 318).background(Color.chillyWhite)
            .border(Color.chillyBlack, width: 2)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    NewAchievementView(store: Store(initialState: NewAchievementView.Reducer.State(
        achievement: .samples[4]
    )) {
        NewAchievementView.Reducer()
    })
}
