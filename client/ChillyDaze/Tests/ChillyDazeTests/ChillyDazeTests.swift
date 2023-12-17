import ComposableArchitecture
import XCTest

@testable import ChillyDaze

@MainActor final class ChillyDazeTests: XCTestCase {
    typealias Reducer = AppReducer

    func testOnAppear() async {
        let store: TestStore = .init(initialState: Reducer.State()) {
            Reducer()
        } withDependencies: {
            $0.authClient = .testValue
            $0.gatewayClient = .testValue
            $0.locationManager = .testValue
        }
    }
}
