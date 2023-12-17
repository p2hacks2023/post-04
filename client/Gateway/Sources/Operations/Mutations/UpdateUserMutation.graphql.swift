// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UpdateUserMutation: GraphQLMutation {
  public static let operationName: String = "UpdateUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UpdateUser($name: String, $avatar: String) { updateUser(input: { name: $name, avatar: $avatar }) { __typename id name avatar { __typename name } } }"#
    ))

  public var name: GraphQLNullable<String>
  public var avatar: GraphQLNullable<String>

  public init(
    name: GraphQLNullable<String>,
    avatar: GraphQLNullable<String>
  ) {
    self.name = name
    self.avatar = avatar
  }

  public var __variables: Variables? { [
    "name": name,
    "avatar": avatar
  ] }

  public struct Data: Gateway.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("updateUser", UpdateUser.self, arguments: ["input": [
        "name": .variable("name"),
        "avatar": .variable("avatar")
      ]]),
    ] }

    public var updateUser: UpdateUser { __data["updateUser"] }

    /// UpdateUser
    ///
    /// Parent Type: `User`
    public struct UpdateUser: Gateway.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Gateway.ID.self),
        .field("name", String.self),
        .field("avatar", Avatar?.self),
      ] }

      public var id: Gateway.ID { __data["id"] }
      public var name: String { __data["name"] }
      public var avatar: Avatar? { __data["avatar"] }

      /// UpdateUser.Avatar
      ///
      /// Parent Type: `Achievement`
      public struct Avatar: Gateway.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Achievement }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
        ] }

        public var name: String { __data["name"] }
      }
    }
  }
}
