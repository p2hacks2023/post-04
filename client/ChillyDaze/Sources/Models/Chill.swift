import CoreLocation
import Foundation
import Gateway
import Resources
import SwiftUI

public struct Chill: Identifiable, Equatable {
    public let id: UUID
    public var traces: [TracePoint]
    public var photo: Photo?
    public var distanceMeters: CLLocationDistance
    // MARK: - Only available in the session
    public var shots: [Shot]?
    // MARK: - Only available end of the session
    public var newAchievements: [Achievement]?

    public init(
        id: UUID = .init(),
        traces: [TracePoint] = [],
        photo: Photo? = nil,
        distanceMeters: CLLocationDistance = 0,
        shots: [Shot]? = nil,
        newAchievements: [Achievement]? = nil
    ) {
        self.id = id
        self.traces = traces
        self.photo = photo
        self.distanceMeters = distanceMeters
        self.shots = shots
        self.newAchievements = newAchievements
    }
}

public extension Chill {
    static func fromGateway(chill: Gateway.ChillsQuery.Data.User.Chill) throws -> Self {
        let traces: [TracePoint] = try chill.traces.map {
            try TracePoint.fromGateway(tracePoint: $0)
        }

        let photo: Photo? = try Photo.fromGateway(photo: chill.photo)

        return .init(
            id: .init(uuidString: chill.id) ?? .init(),
            traces: traces,
            photo: photo,
            distanceMeters: chill.distanceMeters
        )
    }

    static func fromGateway(chill: StartChillMutation.Data.StartChill) throws -> Self {
        let traces: [TracePoint] = try chill.traces.map {
            try TracePoint.fromGateway(tracePoint: $0)
        }

        return .init(
            id: .init(uuidString: chill.id) ?? .init(),
            traces: traces
        )
    }

    static func fromGateway(chill: EndChillMutation.Data.EndChill) throws -> Self {
        let traces: [TracePoint] = try chill.traces.map {
            try TracePoint.fromGateway(tracePoint: $0)
        }

        let photo: Photo? = try Photo.fromGateway(photo: chill.photo)
        let newAchievements = chill.newAchievements.map { Achievement.fromGateway(achievement: $0) }

        return .init(
            id: .init(uuidString: chill.id) ?? .init(),
            traces: traces,
            photo: photo,
            distanceMeters: chill.distanceMeters,
            newAchievements: newAchievements
        )
    }
}

public extension Chill {
    static let samples: [Self] = [
        .init(
            traces: TracePoint.samples,
            shots: Shot.samples
        ),
        .init(
            traces: TracePoint.samples,
            photo: Photo.samples[0],
            newAchievements: [
                .samples[0],
            ]
        ),
        .init(
            traces: TracePoint.samples
        ),
        .init(
            traces: TracePoint.samples
        ),
        .init(
            traces: TracePoint.samples,
            photo: Photo.samples[0]
        ),
        .init(
            traces: TracePoint.samples,
            photo: Photo.samples[1]
        ),
    ]
}
