import ComposableArchitecture
import XCTest

@testable import Record

@MainActor final class RecordTests: XCTestCase {
    typealias Reducer = RecordReducer

    func testOnAppear() async {
        let store: TestStore = .init(initialState: Reducer.State()) { Reducer() }
    }
}
