import SwiftUI

struct ContentView: View {
    @State private var selectedPark: Park = Park.wdwParks[0]
    @State private var showingGlobalSearch = false

    var body: some View {
        TabView(selection: $selectedPark) {
            ForEach(Park.wdwParks) { park in
                NavigationStack {
                    ParkView(park: park)
                }
                .tag(park)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .safeAreaInset(edge: .bottom, spacing: 0) {
            ParkTabBar(selected: $selectedPark, iconFor: tabIcon, onSearch: { showingGlobalSearch = true })
        }
        .preferredColorScheme(.dark)
        .tint(.white)
        .sheet(isPresented: $showingGlobalSearch) {
            GlobalSearchView()
                .environmentObject(WatchlistStore.shared)
        }
    }

    private func tabIcon(for park: Park) -> String {
        switch park.shortName {
        case "MK": return "sparkles"
        case "EP": return "globe.americas.fill"
        case "HS": return "film.fill"
        case "AK": return "pawprint.fill"
        default:   return "mappin"
        }
    }
}

private struct ParkTabBar: View {
    @Binding var selected: Park
    let iconFor: (Park) -> String
    let onSearch: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Park.wdwParks) { park in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selected = park
                    }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: iconFor(park))
                            .font(.system(size: 22))
                        Text(park.shortName)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                    .padding(.bottom, 6)
                    .foregroundStyle(selected == park ? Color.white : Color.white.opacity(0.4))
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(park.name)
                .accessibilityAddTraits(selected == park ? .isSelected : [])
            }

            Button(action: onSearch) {
                VStack(spacing: 3) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22))
                    Text("Search")
                        .font(.system(size: 10, weight: .medium))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 6)
                .foregroundStyle(Color.white.opacity(0.4))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Search all parks")
        }
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Divider().opacity(0.4)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WatchlistStore.shared)
}
