import CoreLocation

public extension CLLocationDistance {
    static func distance(coordinates: [CLLocationCoordinate2D]) -> Self {
        var distance: Self = 0

        coordinates.enumerated().forEach { index, coordinate in
            if index > 0 {
                distance += coordinate.location.distance(from: coordinates[index - 1].location)
            }
        }

        return distance
    }
}
