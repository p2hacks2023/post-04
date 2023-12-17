import Apollo
import ApolloAPI
import Foundation

final class NetworkInterceptorProvider: DefaultInterceptorProvider {

    override public func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation: GraphQLOperation {
        var interceptors: [any ApolloInterceptor] = super.interceptors(for: operation)
        interceptors.insert(AuthorizationInterceptor(), at: 0)
        return interceptors
    }
}
