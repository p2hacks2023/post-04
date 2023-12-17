// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RegisterUserMutation: GraphQLMutation {
  public static let operationName: String = "RegisterUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation RegisterUser($name: String!) { registerUser(input: { name: $name }) { __typename id name } }"#
    ))

  public var name: String

  public init(name: String) {
    self.name = name
  }

  public var __variables: Variables? { ["name": name] }

  public struct Data: Gateway.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("registerUser", RegisterUser.self, arguments: ["input": ["name": .variable("name")]]),
    ] }

    public var registerUser: RegisterUser { __data["registerUser"] }

    /// RegisterUser
    ///
    /// Parent Type: `User`
    public struct RegisterUser: Gateway.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { Gateway.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Gateway.ID.self),
        .field("name", String.self),
      ] }

      public var id: Gateway.ID { __data["id"] }
      public var name: String { __data["name"] }
    }
  }
}
