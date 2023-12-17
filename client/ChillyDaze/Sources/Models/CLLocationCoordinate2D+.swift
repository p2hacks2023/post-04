import CoreLocation
import Gateway

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

public extension CLLocationCoordinate2D {
    var location: CLLocation {
        .init(latitude: self.latitude, longitude: self.longitude)
    }
}

public extension CLLocationCoordinate2D {
    static let samples: [Self] = [
        CLLocationCoordinate2DMake(35.681042, 139.767214),
        CLLocationCoordinate2DMake(35.681434, 139.765729),
        CLLocationCoordinate2DMake(35.681154, 139.765675),
        CLLocationCoordinate2DMake(35.681333, 139.764712),
        CLLocationCoordinate2DMake(35.680460, 139.764410),
        CLLocationCoordinate2DMake(35.680510, 139.764105),
        CLLocationCoordinate2DMake(35.680135, 139.764026),
        CLLocationCoordinate2DMake(35.680176, 139.763855),
    ]
}
