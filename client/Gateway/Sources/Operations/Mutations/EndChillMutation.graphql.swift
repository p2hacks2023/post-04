// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class EndChillMutation: GraphQLMutation {
  public static let operationName: String = "EndChill"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation EndChill($id: ID!, $tracePoints: [TracePointInput!]!, $photo: PhotoInput, $timestamp: DateTime!, $distanceMeters: Float!) { endChill( input: { id: $id, tracePoints: $tracePoints, photo: $photo, timestamp: $timestamp, distanceMeters: $distanceMeters } ) { __typename id traces { __typename id timestamp coordinate { __typename latitude longitude } } photo { __typename id timestamp url } distanceMeters newAchievements { __typename id name displayName description category { __typename id name displayName } } } }"#
    ))

  public var id: ID
  public var tracePoints: [TracePointInput]
  public var photo: GraphQLNullable<PhotoInput>
  public var timestamp: DateTime
  public var distanceMeters: Double

  public init(
    id: ID,
    tracePoints: [TracePointInput],
    photo: GraphQLNullable<PhotoInput>,
    timestamp: DateTime,
    distanceMeters: Double
  ) {
    self.id = id
    self.tracePoints = tracePoints
    self.photo = photo
    self.timestamp = timestamp
    self.distanceMeters = distanceMeters
  }

  public var __variables: Variables? { [
    "id": id,
    "tracePoints": tracePoints,
    "photo": photo,
    "timestamp": timestamp,
    "distanceMeters": distanceMeters
  ] }

  public struct Data: Gateway.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("endChill", EndChill.self, arguments: ["input": [
        "id": .variable("id"),
        "tracePoints": .variable("tracePoints"),
        "photo": .variable("photo"),
        "timestamp": .variable("timestamp"),
        "distanceMeters": .variable("distanceMeters")
      ]]),
    ] }

    public var endChill: EndChill { __data["endChill"] }

    /// EndChill
    ///
    /// Parent Type: `Chill`
    public struct EndChill: Gateway.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Chill }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Gateway.ID.self),
        .field("traces", [Trace].self),
        .field("photo", Photo?.self),
        .field("distanceMeters", Double.self),
        .field("newAchievements", [NewAchievement].self),
      ] }

      public var id: Gateway.ID { __data["id"] }
      public var traces: [Trace] { __data["traces"] }
      public var photo: Photo? { __data["photo"] }
      public var distanceMeters: Double { __data["distanceMeters"] }
      public var newAchievements: [NewAchievement] { __data["newAchievements"] }

      /// EndChill.Trace
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

        /// EndChill.Trace.Coordinate
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

      /// EndChill.Photo
      ///
      /// Parent Type: `Photo`
      public struct Photo: Gateway.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Photo }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Gateway.ID.self),
          .field("timestamp", Gateway.DateTime.self),
          .field("url", String.self),
        ] }

        public var id: Gateway.ID { __data["id"] }
        public var timestamp: Gateway.DateTime { __data["timestamp"] }
        public var url: String { __data["url"] }
      }

      /// EndChill.NewAchievement
      ///
      /// Parent Type: `Achievement`
      public struct NewAchievement: Gateway.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Achievement }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Gateway.ID.self),
          .field("name", String.self),
          .field("displayName", String.self),
          .field("description", String.self),
          .field("category", Category.self),
        ] }

        public var id: Gateway.ID { __data["id"] }
        public var name: String { __data["name"] }
        public var displayName: String { __data["displayName"] }
        public var description: String { __data["description"] }
        public var category: Category { __data["category"] }

        /// EndChill.NewAchievement.Category
        ///
        /// Parent Type: `AchievementCategory`
        public struct Category: Gateway.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.AchievementCategory }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Gateway.ID.self),
            .field("name", String.self),
            .field("displayName", String.self),
          ] }

          public var id: Gateway.ID { __data["id"] }
          public var name: String { __data["name"] }
          public var displayName: String { __data["displayName"] }
        }
      }
    }
  }
}
