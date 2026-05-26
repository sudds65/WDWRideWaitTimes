import SwiftUI

extension Park {
    var accentColor: Color {
        switch shortName {
        case "MK": return Color(red: 0.55, green: 0.35, blue: 0.95)
        case "EP": return Color(red: 0.30, green: 0.65, blue: 1.00)
        case "HS": return Color(red: 1.00, green: 0.55, blue: 0.25)
        case "AK": return Color(red: 0.35, green: 0.85, blue: 0.55)
        default:   return Color.purple
        }
    }
}

struct MagicalBackground: View {
    let accent: Color

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.04, blue: 0.16),
                    Color(red: 0.10, green: 0.06, blue: 0.28),
                    Color(red: 0.18, green: 0.08, blue: 0.38),
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [accent.opacity(0.45), .clear],
                center: .topTrailing,
                startRadius: 0,
                endRadius: 350
            )
            .blendMode(.screen)

            RadialGradient(
                colors: [Color.pink.opacity(0.20), .clear],
                center: .bottomLeading,
                startRadius: 0,
                endRadius: 400
            )
            .blendMode(.screen)

            StarfieldCanvas()

            SparkleAccent(color: accent)
                .opacity(0.55)
        }
        .ignoresSafeArea()
    }
}

// Single Canvas draw of all stars — one view instead of 70 animated Circles
private struct StarfieldCanvas: View {
    private struct Star {
        let x: CGFloat
        let y: CGFloat
        let radius: CGFloat
        let phase: Double
    }

    private let stars: [Star] = (0..<55).map { _ in
        Star(
            x: .random(in: 0...1),
            y: .random(in: 0...1),
            radius: .random(in: 0.5...1.6),
            phase: .random(in: 0...(.pi * 2))
        )
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1/20)) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                for star in stars {
                    let brightness = 0.35 + 0.65 * (0.5 + 0.5 * sin(t * 1.2 + star.phase))
                    let rect = CGRect(
                        x: star.x * size.width - star.radius,
                        y: star.y * size.height - star.radius,
                        width: star.radius * 2,
                        height: star.radius * 2
                    )
                    ctx.fill(
                        Path(ellipseIn: rect),
                        with: .color(.white.opacity(brightness))
                    )
                }
            }
        }
    }
}

private struct SparkleAccent: View {
    let color: Color

    var body: some View {
        Canvas { ctx, size in
            let center = CGPoint(x: size.width * 0.85, y: size.height * 0.12)
            for i in 0..<8 {
                let angle = Double(i) * .pi / 4
                let length: CGFloat = 90
                var path = Path()
                path.move(to: center)
                path.addLine(to: CGPoint(
                    x: center.x + cos(angle) * length,
                    y: center.y + sin(angle) * length
                ))
                ctx.stroke(path, with: .color(color.opacity(0.35)), lineWidth: 1.2)
            }
            ctx.fill(
                Path(ellipseIn: CGRect(x: center.x - 6, y: center.y - 6, width: 12, height: 12)),
                with: .color(.white.opacity(0.9))
            )
        }
    }
}
