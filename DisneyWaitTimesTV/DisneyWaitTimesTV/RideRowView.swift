import SwiftUI

struct RideRowView: View {
    let ride: Ride

    var body: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 6) {
                Text(ride.name)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(ride.isOperating ? .white : .white.opacity(0.55))
                    .lineLimit(2)

                if let single = ride.singleRiderWait, ride.isOperating {
                    Label("Single rider: \(single) min", systemImage: "person")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            Spacer(minLength: 16)
            WaitTimeBadge(ride: ride)
        }
        .padding(.vertical, 12)
        .opacity(ride.isOperating ? 1.0 : 0.55)
    }
}
