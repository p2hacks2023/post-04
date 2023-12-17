// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class StartChillMutation: GraphQLMutation {
  public static let operationName: String = "StartChill"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation StartChill($timestamp: DateTime!, $latitude: Float!, $longitude: Float!) { startChill( input: { timestamp: $timestamp, coordinate: { latitude: $latitude, longitude: $longitude } } ) { __typename id traces { __typename id timestamp coordinate { __typename latitude longitude } } } }"#
    ))

  public var timestamp: DateTime
  public var latitude: Double
  public var longitude: Double

  public init(
    timestamp: DateTime,
    latitude: Double,
    longitude: Double
  ) {
    self.timestamp = timestamp
    self.latitude = latitude
    self.longitude = longitude
  }

  public var __variables: Variables? { [
    "timestamp": timestamp,
    "latitude": latitude,
    "longitude": longitude
  ] }

  public struct Data: Gateway.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("startChill", StartChill.self, arguments: ["input": [
        "timestamp": .variable("timestamp"),
        "coordinate": [
          "latitude": .variable("latitude"),
          "longitude": .variable("longitude")
        ]
      ]]),
    ] }

    public var startChill: StartChill { __data["startChill"] }

    /// StartChill
    ///
    /// Parent Type: `Chill`
    public struct StartChill: Gateway.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Chill }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Gateway.ID.self),
        .field("traces", [Trace].self),
      ] }

      public var id: Gateway.ID { __data["id"] }
      public var traces: [Trace] { __data["traces"] }

      /// StartChill.Trace
      ///
      /// Parent Type: `TracePoint`
      public struct Trace: Gateway.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.TracePoint }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Gateway.ID.self),
          .field("timestamp", Gateway.DateTime.self),
          .field("coordinate", Coordinate.self),
        ] }

        public var id: Gateway.ID { __data["id"] }
        public var timestamp: Gateway.DateTime { __data["timestamp"] }
        public var coordinate: Coordinate { __data["coordinate"] }

        /// StartChill.Trace.Coordinate
        ///
        /// Parent Type: `Coordinate`
        public struct Coordinate: Gateway.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Coordinate }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("latitude", Double.self),
            .field("longitude", Double.self),
          ] }

          public var latitude: Double { __data["latitude"] }
          public var longitude: Double { __data["longitude"] }
        }
      }
    }
  }
}
