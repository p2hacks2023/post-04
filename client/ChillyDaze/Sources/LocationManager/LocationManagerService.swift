import CoreLocation
import Foundation

final class LocationManagerService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationManagerService()

    private let locationManager: CLLocationManager

    private var coordinateChangeHandler: ((CLLocationCoordinate2D) -> Void)?
    var coordinateStream: AsyncStream<CLLocationCoordinate2D> {
        AsyncStream { continuation in
            self.coordinateChangeHandler = { value in
                continuation.yield(value)
            }
        }
    }

    private var degreesChangeHandler: ((CLLocationDirection) -> Void)?
    var degreesStream:  AsyncStream<CLLocationDirection> {
        AsyncStream { continuation in
            self.degreesChangeHandler = { value in
                continuation.yield(value)
            }
        }
    }

    override init() {
        self.locationManager = .init()
        super.init()
        self.locationManager.delegate = self
        if let coordinateStream = self.coordinate {
            self.coordinateChangeHandler?(coordinateStream)
        }
        if let degreesStream = self.direction {
            self.degreesChangeHandler?(degreesStream)
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 5
        self.locationManager.activityType = .fitness
    }

    func requestWhenInUseAuthorization() -> Bool {
        if self.locationManager.authorizationStatus == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
            return requestWhenInUseAuthorization()
        }

        return self.isValidAuthoriztionStatus
    }

    var isValidAuthoriztionStatus: Bool {
        self.locationManager.authorizationStatus == .authorizedWhenInUse
            || self.locationManager.authorizationStatus == .authorizedAlways
    }

    var coordinate: CLLocationCoordinate2D? {
        self.locationManager.location?.coordinate
    }

    var direction: CLLocationDirection? {
        self.locationManager.heading?.magneticHeading
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let coordinate = locations.first?.coordinate {
            self.coordinateChangeHandler?(coordinate)
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateHeading heading: CLHeading
    ) {
        let degrees = heading.magneticHeading
        self.degreesChangeHandler?(degrees)
    }

    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
    }

    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopUpdatingHeading()
    }

    func enableBackgroundMode() {
        self.locationManager.allowsBackgroundLocationUpdates = true
    }

    func disableBackgroundMode() {
        self.locationManager.allowsBackgroundLocationUpdates = false
    }
}
