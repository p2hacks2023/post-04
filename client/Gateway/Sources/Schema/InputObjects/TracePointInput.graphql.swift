// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct TracePointInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    timestamp: DateTime,
    coordinate: CoordinateInput
  ) {
    __data = InputDict([
      "timestamp": timestamp,
      "coordinate": coordinate
    ])
  }

  public var timestamp: DateTime {
    get { __data["timestamp"] }
    set { __data["timestamp"] = newValue }
  }

  public var coordinate: CoordinateInput {
    get { __data["coordinate"] }
    set { __data["coordinate"] = newValue }
  }
}
