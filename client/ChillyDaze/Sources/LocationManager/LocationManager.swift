import CoreLocation
import Foundation
import Models

public struct LocationManager {
    public private(set) var getCurrentLocation: @Sendable () throws -> CLLocationCoordinate2D
    public private(set) var getLocationStream: @Sendable () -> AsyncStream<CLLocationCoordinate2D>
    public private(set) var startUpdatingLocation: @Sendable () throws -> Void
    public private(set) var stopUpdatingLocation: @Sendable () -> Void
    public private(set) var enableBackgroundMode: @Sendable () -> Void
    public private(set) var disableBackgroundMode: @Sendable () -> Void

    public init(
        getCurrentLocation: @escaping @Sendable () throws -> CLLocationCoordinate2D,
        getLocationStream: @escaping @Sendable () -> AsyncStream<CLLocationCoordinate2D>,
        startUpdatingLocation: @escaping @Sendable () throws -> Void,
        stopUpdatingLocation: @escaping @Sendable () -> Void,
        enableBackgroundMode: @escaping @Sendable () -> Void,
        disableBackgroundMode: @escaping @Sendable () -> Void
    ) {
        self.getCurrentLocation = getCurrentLocation
        self.getLocationStream = getLocationStream
        self.startUpdatingLocation = startUpdatingLocation
        self.stopUpdatingLocation = stopUpdatingLocation
        self.enableBackgroundMode = enableBackgroundMode
        self.disableBackgroundMode = disableBackgroundMode
    }
}
