import CoreLocation
import Dependencies
import Foundation

extension LocationManager: DependencyKey {
    public static let liveValue: Self = .init(
        getCurrentLocation: {
            guard let coordinate = LocationManagerService.shared.coordinate else { throw LocationManagerError.failedToGetCoordinate }

            return coordinate
        },
        getLocationStream: {
            LocationManagerService.shared.coordinateStream
        },
        startUpdatingLocation: {
            if !LocationManagerService.shared.requestWhenInUseAuthorization() { throw LocationManagerError.locationServiceIsNotPermitted }

            LocationManagerService.shared.startUpdatingLocation()
        },
        stopUpdatingLocation: {
            LocationManagerService.shared.stopUpdatingLocation()
        },
        enableBackgroundMode: {
            LocationManagerService.shared.enableBackgroundMode()
        },
        disableBackgroundMode: {
            LocationManagerService.shared.disableBackgroundMode()
        }
    )
}

