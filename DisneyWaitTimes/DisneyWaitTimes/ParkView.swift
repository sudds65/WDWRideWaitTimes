import SwiftUI

struct ParkView: View {
    @StateObject private var vm: ParkViewModel
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var watchlist: WatchlistStore
    @State private var rideToWatch: Ride?

    init(park: Park) {
        _vm = StateObject(wrappedValue: ParkViewModel(park: park))
    }

    var body: some View {
        ZStack {
            MagicalBackground(accent: vm.park.accentColor)

            Group {
                if vm.isLoading && vm.rides.isEmpty {
                    ProgressView("Loading wait times…")
                        .tint(.white)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = vm.errorMessage, vm.rides.isEmpty {
                    ErrorView(message: error) {
                        vm.startLoad()
                    }
                } else {
                    rideList
                }
            }
        }
        .navigationTitle("\(vm.park.emoji) \(vm.park.name)")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.hidden, for: .navigationBar)
        .refreshable { await vm.load() }
        .task { vm.startLoad() }
        .onAppear { vm.startAutoRefresh() }
        .onDisappear { vm.stopAll() }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active:
                if vm.rides.isEmpty { vm.startLoad() }
                vm.startAutoRefresh()
            case .inactive, .background:
                vm.stopAll()
            @unknown default:
                break
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let updated = vm.lastUpdated {
                    Text(updated, style: .time)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.75))
                }
            }
        }
        .sheet(item: $rideToWatch) { ride in
            ThresholdPickerView(ride: ride, park: vm.park, watchlist: watchlist)
        }
    }

    private var rideList: some View {
        List {
            if !vm.operatingRides.isEmpty {
                Section {
                    ForEach(vm.operatingRides) { ride in
                        RideRowView(ride: ride, watchThreshold: watchlist.threshold(for: ride.id))
                            .listRowBackground(Color.white.opacity(0.08))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                rideToWatch = ride
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                alertActions(for: ride)
                            }
                    }
                } header: {
                    Text("Open (\(vm.operatingRides.count))")
                        .foregroundColor(.white.opacity(0.85))
                }
            }

            if !vm.closedRides.isEmpty {
                Section {
                    ForEach(vm.closedRides) { ride in
                        RideRowView(ride: ride)
                            .listRowBackground(Color.white.opacity(0.05))
                    }
                } header: {
                    Text("Closed / Down (\(vm.closedRides.count))")
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private func alertActions(for ride: Ride) -> some View {
        if watchlist.threshold(for: ride.id) != nil {
            Button(role: .destructive) {
                watchlist.unwatch(rideId: ride.id)
            } label: {
                Label("Remove Alert", systemImage: "bell.slash.fill")
            }
            Button {
                rideToWatch = ride
            } label: {
                Label("Edit Alert", systemImage: "bell.badge")
            }
            .tint(.blue)
        } else {
            Button {
                rideToWatch = ride
            } label: {
                Label("Set Alert", systemImage: "bell.fill")
            }
            .tint(.indigo)
        }
    }
}

// MARK: - Threshold Picker Sheet

struct ThresholdPickerView: View {
    let ride: Ride
    let park: Park
    let watchlist: WatchlistStore
    @Environment(\.dismiss) private var dismiss
    @State private var threshold: Int
    @State private var direction: AlertDirection

    private let options = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 75, 90]

    init(ride: Ride, park: Park, watchlist: WatchlistStore) {
        self.ride = ride
        self.park = park
        self.watchlist = watchlist
        let existing = watchlist.watch(for: ride.id)
        _threshold = State(initialValue: existing?.thresholdMinutes ?? 30)
        _direction = State(initialValue: existing?.direction ?? .below)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Direction", selection: $direction) {
                        ForEach(AlertDirection.allCases, id: \.self) { d in
                            Text(d.label).tag(d)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Notify me when \"\(ride.name)\"")
                }

                Section {
                    Picker("Minutes", selection: $threshold) {
                        ForEach(options, id: \.self) { min in
                            Text("\(min) min").tag(min)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                }

                Section {
                    Label(infoText, systemImage: "info.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Wait Time Alert")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        watchlist.watch(ride: ride, park: park, threshold: threshold, direction: direction)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .safeAreaInset(edge: .bottom) {
                if watchlist.threshold(for: ride.id) != nil {
                    Button(role: .destructive) {
                        watchlist.unwatch(rideId: ride.id)
                        dismiss()
                    } label: {
                        Label("Remove Alert", systemImage: "bell.slash.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private var infoText: String {
        switch direction {
        case .below:
            return "You'll get an alert each time the wait hits a new low under \(threshold) minutes. Alerts reset when the wait rises back above your threshold."
        case .above:
            return "You'll get an alert each time the wait hits a new high over \(threshold) minutes. Alerts reset when the wait drops back below your threshold."
        }
    }
}

// MARK: - Error View

struct ErrorView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.8))
            Text("Couldn't load wait times")
                .font(.headline)
                .foregroundColor(.white)
            Text(message)
                .font(.caption)
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Try Again", action: retry)
                .buttonStyle(.borderedProminent)
                .tint(.white.opacity(0.9))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

