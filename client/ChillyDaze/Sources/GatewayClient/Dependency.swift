import Dependencies

public extension DependencyValues {
    var gatewayClient: GatewayClient {
        get { self[GatewayClient.self] }
        set { self[GatewayClient.self] = newValue }
    }
}
