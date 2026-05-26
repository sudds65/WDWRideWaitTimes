import SwiftUI
import UserNotifications

@main
struct DisneyWaitTimesApp: App {
    @Environment(\.scenePhase) private var scenePhase

    init() {
        let nm = NotificationManager.shared
        UNUserNotificationCenter.current().delegate = nm
        nm.requestPermission()
        BackgroundRefreshManager.shared.register()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(WatchlistStore.shared)
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {
                BackgroundRefreshManager.shared.schedule()
            }
        }
    }
}
