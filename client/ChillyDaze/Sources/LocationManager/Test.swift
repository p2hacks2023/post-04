import CoreLocation
import Dependencies
import Foundation

extension LocationManager: TestDependencyKey {
    public static let testValue: Self = .init(
        getCurrentLocation: {
            CLLocationCoordinate2DMake(35.681042, 139.767214)
        },
        getLocationStream: unimplemented("\(Self.self)"),
        startUpdatingLocation: {},
        stopUpdatingLocation: {},
        enableBackgroundMode: {},
        disableBackgroundMode: {}
    )

    public static let previewValue = Self.testValue
}
