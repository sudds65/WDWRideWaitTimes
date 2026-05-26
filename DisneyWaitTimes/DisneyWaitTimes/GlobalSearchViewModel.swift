import Foundation

struct ParkRide: Identifiable {
    let park: Park
    let ride: Ride
    var id: String { ride.id }
}

@MainActor
final class GlobalSearchViewModel: ObservableObject {
    @Published var ridesByPark: [String: [Ride]] = [:]
    @Published var isLoading = false

    private let service = WaitTimeService()
    private var loadTask: Task<Void, Never>?

    func loadAll() {
        guard ridesByPark.isEmpty else { return }
        loadTask?.cancel()
        loadTask = Task {
            isLoading = true
            await withTaskGroup(of: (String, [Ride]).self) { group in
                for park in Park.wdwParks {
                    group.addTask {
                        let rides = (try? await self.service.fetchRides(for: park)) ?? []
                        return (park.id, rides)
                    }
                }
                for await (parkId, rides) in group {
                    ridesByPark[parkId] = rides
                }
            }
            isLoading = false
        }
    }

    func cancel() {
        loadTask?.cancel()
        loadTask = nil
    }

    func results(for query: String) -> [ParkRide] {
        guard !query.isEmpty else { return [] }
        let q = query.lowercased()
        return Park.wdwParks.flatMap { park in
            (ridesByPark[park.id] ?? [])
                .filter { $0.name.lowercased().contains(q) }
                .sorted { ($0.waitMinutes ?? -1) > ($1.waitMinutes ?? -1) }
                .map { ParkRide(park: park, ride: $0) }
        }
    }
}
