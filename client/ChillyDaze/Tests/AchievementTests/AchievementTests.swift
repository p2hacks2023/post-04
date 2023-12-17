import ComposableArchitecture
import XCTest

@testable import Achievement

@MainActor final class AchievementTests: XCTestCase {
    typealias Reducer = AchievementReducer

    func testOnAppear() async {
        let store: TestStore = .init(initialState: Reducer.State()) {
            Reducer()
        } withDependencies: {
            $0.gatewayClient = .testValue
        }
    }
}
