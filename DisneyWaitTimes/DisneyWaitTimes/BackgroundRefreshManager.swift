import BackgroundTasks
import Foundation

final class BackgroundRefreshManager {
    static let shared = BackgroundRefreshManager()

    static let taskIdentifier = "com.disney.waitimes.refresh"

    func register() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Self.taskIdentifier,
            using: nil
        ) { task in
            self.handleRefresh(task: task as! BGAppRefreshTask)
        }
    }

    func schedule() {
        let request = BGAppRefreshTaskRequest(identifier: Self.taskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        try? BGTaskScheduler.shared.submit(request)
    }

    private func handleRefresh(task: BGAppRefreshTask) {
        schedule()

        let fetchTask = Task { @MainActor in
            let watchedParkIds = Set(WatchlistStore.shared.watches.values.map(\.parkId))
            let parks = Park.wdwParks.filter { watchedParkIds.contains($0.id) }
            let service = WaitTimeService()

            for park in parks {
                if Task.isCancelled { break }
                if let rides = try? await service.fetchRides(for: park) {
                    WatchlistStore.shared.checkThresholds(rides: rides, park: park)
                }
            }
            task.setTaskCompleted(success: !Task.isCancelled)
        }

        task.expirationHandler = {
            fetchTask.cancel()
        }
    }
}
