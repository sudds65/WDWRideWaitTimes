import Foundation

@MainActor
class ParkViewModel: ObservableObject {
    @Published var rides: [Ride] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var lastUpdated: Date?

    let park: Park
    private let service = WaitTimeService()
    private var loadTask: Task<Void, Never>?
    private var refreshTask: Task<Void, Never>?
    private let refreshInterval: TimeInterval = 60

    init(park: Park) {
        self.park = park
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            rides = try await service.fetchRides(for: park)
            lastUpdated = Date()
            WatchlistStore.shared.checkThresholds(rides: rides, park: park)
        } catch {
            if !Task.isCancelled {
                errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }

    func startLoad() {
        loadTask?.cancel()
        loadTask = Task { await load() }
    }

    func startAutoRefresh() {
        guard refreshTask == nil else { return }
        refreshTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: UInt64(self.refreshInterval * 1_000_000_000))
                if Task.isCancelled { break }
                await self.load()
            }
        }
    }

    func stopAll() {
        loadTask?.cancel()
        loadTask = nil
        refreshTask?.cancel()
        refreshTask = nil
        isLoading = false
    }

    var operatingRides: [Ride] { rides.filter { $0.isOperating } }
    var closedRides: [Ride] { rides.filter { !$0.isOperating } }
}
