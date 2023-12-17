// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == Gateway.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == Gateway.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == Gateway.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == Gateway.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Query": return Gateway.Objects.Query
    case "User": return Gateway.Objects.User
    case "Achievement": return Gateway.Objects.Achievement
    case "AchievementCategory": return Gateway.Objects.AchievementCategory
    case "Chill": return Gateway.Objects.Chill
    case "TracePoint": return Gateway.Objects.TracePoint
    case "Coordinate": return Gateway.Objects.Coordinate
    case "Photo": return Gateway.Objects.Photo
    case "Mutation": return Gateway.Objects.Mutation
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
