// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct PhotoInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    url: String,
    timestamp: DateTime
  ) {
    __data = InputDict([
      "url": url,
      "timestamp": timestamp
    ])
  }

  public var url: String {
    get { __data["url"] }
    set { __data["url"] = newValue }
  }

  public var timestamp: DateTime {
    get { __data["timestamp"] }
    set { __data["timestamp"] = newValue }
  }
}
