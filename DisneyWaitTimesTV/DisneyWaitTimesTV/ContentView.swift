import SwiftUI

struct ContentView: View {
    @State private var selectedPark: Park = Park.wdwParks[0]

    var body: some View {
        TabView(selection: $selectedPark) {
            ForEach(Park.wdwParks) { park in
                ParkView(park: park, selection: $selectedPark)
                    .tabItem {
                        Text("\(park.emoji)  \(park.shortName)")
                    }
                    .tag(park)
            }
        }
    }
}

#Preview {
    ContentView()
}
