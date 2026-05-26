import SwiftUI

struct ParkView: View {
    @StateObject private var vm: ParkViewModel
    @Binding var selection: Park
    @Environment(\.scenePhase) private var scenePhase

    init(park: Park, selection: Binding<Park>) {
        _vm = StateObject(wrappedValue: ParkViewModel(park: park))
        _selection = selection
    }

    var body: some View {
        ZStack {
            MagicalBackground(accent: vm.park.accentColor)

            VStack(spacing: 0) {
                header

                if vm.isLoading && vm.rides.isEmpty {
                    Spacer()
                    ProgressView("Loading wait times…")
                        .font(.system(size: 28))
                        .tint(.white)
                        .foregroundColor(.white)
                    Spacer()
                } else if let error = vm.errorMessage, vm.rides.isEmpty {
                    Spacer()
                    ErrorView(message: error) {
                        vm.startLoad()
                    }
                    Spacer()
                } else {
                    rideList
                }
            }
        }
        .onMoveCommand { direction in
            switch direction {
            case .left:  shiftPark(-1)
            case .right: shiftPark(+1)
            default:     break
            }
        }
        .task { vm.startLoad() }
        .onAppear { vm.startAutoRefresh() }
        .onDisappear { vm.stopAll() }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active:
                vm.startAutoRefresh()
            case .inactive, .background:
                vm.stopAll()
            @unknown default:
                break
            }
        }
    }

    private func shiftPark(_ delta: Int) {
        guard let idx = Park.wdwParks.firstIndex(of: selection) else { return }
        let count = Park.wdwParks.count
        let newIdx = (idx + delta + count) % count
        withAnimation(.easeInOut(duration: 0.25)) {
            selection = Park.wdwParks[newIdx]
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            Text(vm.park.emoji)
                .font(.system(size: 56))
            Text(vm.park.name)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Button {
                    vm.startLoad()
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                        .font(.system(size: 22, weight: .medium))
                }
                .buttonStyle(.bordered)

                if let updated = vm.lastUpdated {
                    Text("Updated \(updated, style: .time)")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, 60)
        .padding(.top, 30)
        .padding(.bottom, 20)
    }

    private var rideList: some View {
        ScrollView {
            LazyVStack(spacing: 6) {
                if !vm.operatingRides.isEmpty {
                    sectionHeader("Open (\(vm.operatingRides.count))")
                    ForEach(vm.operatingRides) { ride in
                        FocusableRideRow(ride: ride)
                    }
                }

                if !vm.closedRides.isEmpty {
                    sectionHeader("Closed / Down (\(vm.closedRides.count))")
                    ForEach(vm.closedRides) { ride in
                        FocusableRideRow(ride: ride)
                    }
                }
            }
            .padding(.bottom, 60)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))
                .textCase(.uppercase)
                .tracking(1.2)
            Spacer()
        }
        .padding(.horizontal, 80)
        .padding(.top, 30)
        .padding(.bottom, 10)
    }
}

// Focusable wrapper so the tvOS focus engine can scroll the list
private struct FocusableRideRow: View {
    let ride: Ride
    @FocusState private var isFocused: Bool

    var body: some View {
        RideRowView(ride: ride)
            .padding(.horizontal, 32)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isFocused
                          ? Color.white.opacity(0.18)
                          : Color.white.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(
                        isFocused ? Color.white.opacity(0.6) : Color.clear,
                        lineWidth: 2
                    )
            )
            .padding(.horizontal, 60)
            .scaleEffect(isFocused ? 1.015 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isFocused)
            .focusable()
            .focused($isFocused)
    }
}

struct ErrorView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 72))
                .foregroundColor(.white.opacity(0.85))
            Text("Couldn't load wait times")
                .font(.system(size: 36, weight: .semibold))
                .foregroundColor(.white)
            Text(message)
                .font(.system(size: 22))
                .foregroundColor(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 80)
            Button("Try Again", action: retry)
                .font(.system(size: 24, weight: .medium))
                .buttonStyle(.borderedProminent)
        }
    }
}
