import Foundation

// MARK: - API Response Models

struct DestinationsResponse: Codable {
    let destinations: [Destination]
}

struct Destination: Codable {
    let id: String
    let name: String
    let parks: [ParkRef]
}

struct ParkRef: Codable {
    let id: String
    let name: String
}

struct LiveDataResponse: Codable {
    let liveData: [LiveRideData]
}

struct LiveRideData: Codable {
    let id: String
    let name: String
    let entityType: String
    let status: RideStatus?
    let queue: QueueInfo?
}

enum RideStatus: String, Codable {
    case operating = "OPERATING"
    case down = "DOWN"
    case closed = "CLOSED"
    case refurbishment = "REFURBISHMENT"

    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = RideStatus(rawValue: raw) ?? .closed
    }
}

struct QueueInfo: Codable {
    let STANDBY: StandbyQueue?
    let SINGLE_RIDER: StandbyQueue?
}

struct StandbyQueue: Codable {
    let waitTime: Int?
}

// MARK: - App Models

struct Park: Identifiable, Hashable {
    let id: String
    let name: String
    let shortName: String
    let emoji: String
}

struct Ride: Identifiable {
    let id: String
    let name: String
    let status: RideStatus
    let waitMinutes: Int?
    let singleRiderWait: Int?

    var isOperating: Bool { status == .operating }

    var waitColor: WaitColor {
        guard let wait = waitMinutes else { return .unknown }
        switch wait {
        case 0..<20: return .low
        case 20..<45: return .medium
        default: return .high
        }
    }

    var waitLabel: String {
        switch status {
        case .operating:
            if let wait = waitMinutes {
                return wait == 0 ? "Walk on" : "\(wait) min"
            }
            return "Open"
        case .down:
            return "Down"
        case .closed:
            return "Closed"
        case .refurbishment:
            return "Refurb"
        }
    }
}

enum WaitColor {
    case low, medium, high, unknown
}

// MARK: - Static Park Definitions

extension Park {
    static let wdwParks: [Park] = [
        Park(
            id: "75ea578a-adc8-4116-a54d-dccb60765ef9",
            name: "Magic Kingdom",
            shortName: "Magic Kingdom",
            emoji: "🏰"
        ),
        Park(
            id: "47f90d2c-e191-4239-a466-5892ef59a88b",
            name: "EPCOT",
            shortName: "EPCOT",
            emoji: "🌍"
        ),
        Park(
            id: "288747d1-8b4f-4a64-867e-ea7c9b27bad8",
            name: "Hollywood Studios",
            shortName: "Hollywood Studios",
            emoji: "🎬"
        ),
        Park(
            id: "1c84a229-8862-4648-9c71-378ddd2c7693",
            name: "Animal Kingdom",
            shortName: "Animal Kingdom",
            emoji: "🦁"
        ),
    ]
}
