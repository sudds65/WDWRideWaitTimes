import SwiftUI

struct RideRowView: View {
    let ride: Ride
    var watchThreshold: Int? = nil

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 5) {
                    Text(ride.name)
                        .font(.body)
                        .foregroundColor(ride.isOperating ? .white : .white.opacity(0.6))
                    if let t = watchThreshold {
                        Image(systemName: "bell.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow.opacity(0.85))
                            .accessibilityLabel("Alert set for \(t) min")
                    }
                }

                if let single = ride.singleRiderWait, ride.isOperating {
                    Label("Single rider: \(single) min", systemImage: "person")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            Spacer()
            WaitTimeBadge(ride: ride)
        }
        .padding(.vertical, 2)
        .opacity(ride.isOperating ? 1.0 : 0.6)
    }
}
