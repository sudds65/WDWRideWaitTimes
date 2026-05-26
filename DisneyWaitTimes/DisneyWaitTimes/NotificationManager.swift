import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private override init() {}

    func requestPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func send(ride: Ride, wait: Int, park: Park, threshold: Int, direction: AlertDirection) {
        let content = UNMutableNotificationContent()
        content.title = "\(park.emoji) \(ride.name)"
        let waitDesc = wait == 0 ? "Walk-on!" : "\(wait) min wait"
        let comparison = direction == .below ? "under" : "over"
        content.body = "\(waitDesc) — \(comparison) your \(threshold) min alert at \(park.name)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "ride-alert-\(ride.id)",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    // Show banners even while the app is in the foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}
