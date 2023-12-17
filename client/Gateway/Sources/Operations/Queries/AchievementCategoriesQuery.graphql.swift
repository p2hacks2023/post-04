// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AchievementCategoriesQuery: GraphQLQuery {
  public static let operationName: String = "AchievementCategories"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query AchievementCategories { achievementCategories { __typename id name displayName } }"#
    ))

  public init() {}

  public struct Data: Gateway.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("achievementCategories", [AchievementCategory].self),
    ] }

    public var achievementCategories: [AchievementCategory] { __data["achievementCategories"] }

    /// AchievementCategory
    ///
    /// Parent Type: `AchievementCategory`
    public struct AchievementCategory: Gateway.SelectionSet {
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
