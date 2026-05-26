import SwiftUI

struct GlobalSearchView: View {
    @StateObject private var vm = GlobalSearchViewModel()
    @EnvironmentObject private var watchlist: WatchlistStore
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var rideToWatch: Ride?

    var body: some View {
        NavigationStack {
            ZStack {
                MagicalBackground(accent: .purple)

                Group {
                    if vm.isLoading {
                        ProgressView("Loading all parks…")
                            .tint(.white)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if query.isEmpty {
                        Text("Search rides across all 4 parks")
                            .foregroundColor(.white.opacity(0.5))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        resultsList
                    }
                }
            }
            .navigationTitle("Search All Parks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search rides")
        }
        .task { vm.loadAll() }
        .onDisappear { vm.cancel() }
        .sheet(item: $rideToWatch) { ride in
            if let park = Park.wdwParks.first(where: { vm.ridesByPark[$0.id]?.contains(where: { $0.id == ride.id }) == true }) {
                ThresholdPickerView(ride: ride, park: park, watchlist: watchlist)
            }
        }
    }

    private var resultsList: some View {
        let results = vm.results(for: query)
        return List {
            if results.isEmpty {
                ContentUnavailableView.search(text: query)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(results) { pr in
                    HStack {
                        Text(pr.park.emoji)
                            .font(.system(size: 18))
                        RideRowView(ride: pr.ride, watchThreshold: watchlist.threshold(for: pr.ride.id))
                    }
                    .listRowBackground(Color.white.opacity(0.08))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if pr.ride.isOperating { rideToWatch = pr.ride }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }
}
