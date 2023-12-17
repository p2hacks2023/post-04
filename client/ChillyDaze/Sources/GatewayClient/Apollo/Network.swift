import Apollo
import Foundation

final class Network {
    static let shared = Network()

    let apollo: ApolloClient = {
        let client: URLSessionClient = .init()
        let cache: InMemoryNormalizedCache = .init()
        let store: ApolloStore = .init(cache: cache)
        let provider: NetworkInterceptorProvider = .init(client: client, store: store)
        let url: URL = .init(string: "https://chilly-daze-gateway-3nppnwp3sq-an.a.run.app/")!
        let transport: RequestChainNetworkTransport = .init(interceptorProvider: provider, endpointURL: url)

        return ApolloClient(networkTransport: transport, store: store)
    }()
}
