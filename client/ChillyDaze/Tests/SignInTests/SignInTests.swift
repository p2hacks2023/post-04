import ComposableArchitecture
import XCTest

@testable import SignIn

@MainActor final class SignInTests: XCTestCase {
    typealias Reducer = SignInReducer

    func testOnAppear() async {
        let store: TestStore = .init(initialState: Reducer.State()) {
            Reducer()
        } withDependencies: {
            $0.authClient = .testValue
            $0.gatewayClient = .testValue
        }
    }
}
