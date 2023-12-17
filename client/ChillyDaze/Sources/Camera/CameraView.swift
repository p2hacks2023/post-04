import ComposableArchitecture
import Resources
import SwiftUI

public struct CameraView: View {
    public typealias Reducer = CameraReducer
    private let store: StoreOf<Reducer>
    @StateObject private var viewStore: ViewStoreOf<Reducer>

    public init(store: StoreOf<Reducer>) {
        Font.registerCustomFonts()
        self.store = store
        self._viewStore = .init(wrappedValue: ViewStore(store, observe: { $0 }))
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()

                Button {
                    self.viewStore.send(.onXButtonTapped)
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.chillyWhite)
                        .padding(8)
                        .background(Color.chillyBlack)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            Rectangle()
                .fill(Color.chillyBlack)
                .frame(height: 2)

            Group {
                if let shotImage = self.viewStore.shotImage {
                    Image(uiImage: shotImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    ViewFinderView(image: self.viewStore.previewImage)
                }
            }
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.width
            )
            .clipped()

            Rectangle()
                .fill(Color.chillyBlack)
                .frame(height: 2)

            Spacer()

            Group {
                if let shotImage = self.viewStore.shotImage {
                    Button{
                        self.viewStore.send(.onRecordButtonTapped(shotImage))
                    } label: {
                        HStack {
                            Text("Clip")

                            Image(systemName: "paperclip")
                        }
                        .font(.customFont(.inikaBold, size: 20))
                        .padding(.horizontal, 40)
                        .foregroundStyle(Color.chillyBlack).frame(height: 54)
                        .background(Color.chillyYellow).border(Color.chillyBlack, width: 2)
                    }
                } else {
                    Button {
                        self.viewStore.send(.onShutterButtonTapped)
                    } label: {
                        Image.shutterButton
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                }
            }
            .frame(height: 60)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.chillyWhite)
        .onAppear {
            self.viewStore.send(.onAppear)
        }
    }
}

#Preview {
    CameraView(store: Store(initialState: CameraView.Reducer.State()) {
        CameraView.Reducer()
    })
}
