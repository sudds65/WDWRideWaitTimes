import SwiftUI

struct WaitTimeBadge: View {
    let ride: Ride

    private var badgeColor: Color {
        switch ride.waitColor {
        case .low:     return .green
        case .medium:  return .orange
        case .high:    return Color(red: 0.85, green: 0.1, blue: 0.1)
        case .unknown: return .gray
        }
    }

    var body: some View {
        Text(ride.waitLabel)
            .font(.system(size: 32, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .background(badgeColor)
            .clipShape(Capsule())
            .frame(minWidth: 180)
    }
}
