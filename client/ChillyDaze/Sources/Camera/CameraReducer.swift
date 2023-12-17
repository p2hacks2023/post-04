import ComposableArchitecture
import Models
import Resources
import SwiftUI

@Reducer
public struct CameraReducer {
    // MARK: - State
    public struct State: Equatable {
        let camera: Camera = .init()
        var previewImage: UIImage
        var shotImage: UIImage?

        public init() {
            self.previewImage = UIImage.appIcon
        }
    }

    // MARK: - Action
    public enum Action {
        case onAppear
        case refreshPreview(UIImage?)
        case onXButtonTapped
        case onShutterButtonTapped
        case onRecordButtonTapped(UIImage)
    }

    // MARK: - Dependencies

    public init() {}

    public enum CancelID {
        case cameraPreviewImageStreamSubscription
    }

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [camera = state.camera] send in
                    await camera.start()

                    let imageStream = camera.previewStream
                        .map { $0.uiImage }


                    for await image in imageStream {
                        Task { @MainActor in
                            send(.refreshPreview(image))
                        }
                    }
                }
                .cancellable(id: CancelID.cameraPreviewImageStreamSubscription)

            case let .refreshPreview(image):
                if let image = image {
                    state.previewImage = image
                }
                return .none

            case .onXButtonTapped:
                Task.cancel(id: CancelID.cameraPreviewImageStreamSubscription)
                state.camera.stop()
                return .none

            case .onShutterButtonTapped:
                state.shotImage = state.previewImage

                Task.cancel(id: CancelID.cameraPreviewImageStreamSubscription)
                state.camera.stop()

                return .none

            case .onRecordButtonTapped(_):
                return .none
            }
        }
    }
}
