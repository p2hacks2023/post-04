import CloudStorageClient
import ComposableArchitecture
import GatewayClient
import Models
import SwiftUI

@Reducer
public struct WelcomeBackReducer {
    // MARK: - State
    public struct State: Equatable {
        var chill: Chill
        var imageIndex: Int
        var chillRate: CGFloat {
            self.chill.distanceMeters / 1000
        }
        var chillRatePercent: Int {
            Int(self.chillRate * 100)
        }
        var shots: [Shot]? {
            self.chill.shots
        }
        var currentShot: Shot? {
            guard let shots = self.shots else { return nil }
            return shots[self.imageIndex]
        }
        var currentImage: UIImage? {
            guard let shot = self.currentShot else { return nil }
            return shot.image
        }

        var shareImage: UIImage?

        var finalShot: Shot? {
            guard let image = self.shareImage else { return nil }

            if let currentShot = currentShot {
                return .init(timestamp: currentShot.timestamp, image: image)
            }

            return .init(timestamp: .now, image: image)
        }

        public init(chill: Chill) {
            self.chill = chill
            self.imageIndex = 0
        }
    }

    // MARK: - Action
    public enum Action {
        case onAppear

        case getSharingImageResult(UIImage?)

        case onPreviousButtonTapped
        case onNextButtonTapped

        case onOkButtonTapped(Shot)

        case savePhotoResult(Result<Photo, Error>)
        case stopChillResult(Result<Chill, Error>)
    }

    // MARK: - Dependencies
    @Dependency(\.cloudStorageClient)
    private var cloudStorageClient
    @Dependency(\.gatewayClient)
    private var gatewayClient

    init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { @MainActor [state] send in
                    send(.getSharingImageResult(
                        ImageRenderer.getImage(
                            content: WelcomeBackImageView(
                                uiImage: state.currentImage,
                                chillRate: state.chillRate
                            )
                        )
                    ))
                }

            case let .getSharingImageResult(image):
                state.shareImage = image
                return .none

            case .onPreviousButtonTapped:
                if (state.imageIndex > 0) {
                    state.imageIndex -= 1
                }
                return .none

            case .onNextButtonTapped:
                guard let shots = state.shots else { return .none }
                if (state.imageIndex < shots.count - 1) {
                    state.imageIndex += 1
                }
                return .none

            case let .onOkButtonTapped(shot):
                return .run { send in
                    await send(.savePhotoResult(Result {
                        let data = shot.image.jpegData(compressionQuality: 0.5)
                        let url = try await self.cloudStorageClient.uploadData(data, "\(UUID().uuidString).jpg")
                        let photo: Photo = .init(timestamp: shot.timestamp, url: url)
                        return photo
                    }))
                }

            case let .savePhotoResult(.success(photo)):
                state.chill.photo = photo

                return .run { [chill = state.chill] send in
                    await send(
                        .stopChillResult(Result {
                            try await self.gatewayClient.endChill(
                                chill.id.uuidString,
                                chill.traces,
                                chill.photo,
                                chill.distanceMeters,
                                .now
                            )
                        })
                    )
                }

            case .savePhotoResult(.failure(_)):
                return .none

            case .stopChillResult(.success(_)):
                return .none

            case .stopChillResult(.failure(_)):
                return .none
            }
        }
    }
}
 
