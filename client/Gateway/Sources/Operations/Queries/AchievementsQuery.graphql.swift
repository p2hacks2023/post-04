// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AchievementsQuery: GraphQLQuery {
  public static let operationName: String = "Achievements"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Achievements { achievements { __typename id name displayName description category { __typename id name displayName } } }"#
    ))

  public init() {}

  public struct Data: Gateway.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("achievements", [Achievement].self),
    ] }

    public var achievements: [Achievement] { __data["achievements"] }

    /// Achievement
    ///
    /// Parent Type: `Achievement`
    public struct Achievement: Gateway.SelectionSet {
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

      /// Achievement.Category
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
