// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ChillsQuery: GraphQLQuery {
  public static let operationName: String = "Chills"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Chills { user { __typename chills { __typename id traces { __typename id timestamp coordinate { __typename latitude longitude } } photo { __typename id url timestamp } distanceMeters } } }"#
    ))

  public init() {}

  public struct Data: Gateway.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User.self),
    ] }

    public var user: User { __data["user"] }

    /// User
    ///
    /// Parent Type: `User`
    public struct User: Gateway.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("chills", [Chill].self),
      ] }

      public var chills: [Chill] { __data["chills"] }

      /// User.Chill
      ///
      /// Parent Type: `Chill`
      public struct Chill: Gateway.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Chill }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Gateway.ID.self),
          .field("traces", [Trace].self),
          .field("photo", Photo?.self),
          .field("distanceMeters", Double.self),
        ] }

        public var id: Gateway.ID { __data["id"] }
        public var traces: [Trace] { __data["traces"] }
        public var photo: Photo? { __data["photo"] }
        public var distanceMeters: Double { __data["distanceMeters"] }

        /// User.Chill.Trace
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

          /// User.Chill.Trace.Coordinate
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

        /// User.Chill.Photo
        ///
        /// Parent Type: `Photo`
        public struct Photo: Gateway.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Photo }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Gateway.ID.self),
            .field("url", String.self),
            .field("timestamp", Gateway.DateTime.self),
          ] }

          public var id: Gateway.ID { __data["id"] }
          public var url: String { __data["url"] }
          public var timestamp: Gateway.DateTime { __data["timestamp"] }
        }
      }
    }
  }
}
