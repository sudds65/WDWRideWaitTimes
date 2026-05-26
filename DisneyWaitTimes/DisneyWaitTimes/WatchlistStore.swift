import Foundation

enum AlertDirection: String, Codable, CaseIterable {
    case below
    case above

    var label: String {
        switch self {
        case .below: return "Drops below"
        case .above: return "Rises above"
        }
    }
}

struct WatchedRide: Codable {
    let rideId: String
    let rideName: String
    let parkId: String
    var thresholdMinutes: Int
    var direction: AlertDirection

    init(rideId: String, rideName: String, parkId: String, thresholdMinutes: Int, direction: AlertDirection) {
        self.rideId = rideId
        self.rideName = rideName
        self.parkId = parkId
        self.thresholdMinutes = thresholdMinutes
        self.direction = direction
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        rideId = try c.decode(String.self, forKey: .rideId)
        rideName = try c.decode(String.self, forKey: .rideName)
        parkId = try c.decode(String.self, forKey: .parkId)
        thresholdMinutes = try c.decode(Int.self, forKey: .thresholdMinutes)
        direction = (try? c.decode(AlertDirection.self, forKey: .direction)) ?? .below
    }
}

@MainActor
final class WatchlistStore: ObservableObject {
    static let shared = WatchlistStore()

    @Published private(set) var watches: [String: WatchedRide] = [:]
    // rideId → wait time that triggered the last notification; cleared when wait crosses back across threshold
    private var lastNotifiedWaits: [String: Int] = [:]

    private let storeKey = "WatchedRides"

    private init() { load() }

    func watch(ride: Ride, park: Park, threshold: Int, direction: AlertDirection) {
        watches[ride.id] = WatchedRide(
            rideId: ride.id,
            rideName: ride.name,
            parkId: park.id,
            thresholdMinutes: threshold,
            direction: direction
        )
        lastNotifiedWaits.removeValue(forKey: ride.id)
        save()
    }

    func unwatch(rideId: String) {
        watches.removeValue(forKey: rideId)
        lastNotifiedWaits.removeValue(forKey: rideId)
        save()
    }

    func watch(for rideId: String) -> WatchedRide? {
        watches[rideId]
    }

    func threshold(for rideId: String) -> Int? {
        watches[rideId]?.thresholdMinutes
    }

    // Called after every data refresh. Fires a notification when a watched ride
    // crosses its threshold in the configured direction (new low for .below, new high for .above).
    func checkThresholds(rides: [Ride], park: Park) {
        for ride in rides {
            guard let watch = watches[ride.id] else { continue }

            guard ride.isOperating, let wait = ride.waitMinutes else {
                lastNotifiedWaits.removeValue(forKey: ride.id)
                continue
            }

            let inAlertZone: Bool
            let isNewExtreme: Bool
            switch watch.direction {
            case .below:
                inAlertZone = wait < watch.thresholdMinutes
                isNewExtreme = lastNotifiedWaits[ride.id].map { wait < $0 } ?? true
            case .above:
                inAlertZone = wait > watch.thresholdMinutes
                isNewExtreme = lastNotifiedWaits[ride.id].map { wait > $0 } ?? true
            }

            if inAlertZone {
                if isNewExtreme {
                    NotificationManager.shared.send(
                        ride: ride, wait: wait, park: park,
                        threshold: watch.thresholdMinutes, direction: watch.direction
                    )
                    lastNotifiedWaits[ride.id] = wait
                }
            } else {
                lastNotifiedWaits.removeValue(forKey: ride.id)
            }
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(Array(watches.values)) {
            UserDefaults.standard.set(data, forKey: storeKey)
        }
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: storeKey),
            let arr = try? JSONDecoder().decode([WatchedRide].self, from: data)
        else { return }
        watches = Dictionary(uniqueKeysWithValues: arr.map { ($0.rideId, $0) })
    }
}
