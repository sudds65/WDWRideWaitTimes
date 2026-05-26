import Foundation

@MainActor
class WaitTimeService: ObservableObject {
    private let baseURL = "https://api.themeparks.wiki/v1"

    func fetchRides(for park: Park) async throws -> [Ride] {
        let url = URL(string: "\(baseURL)/entity/\(park.id)/live")!
        var request = URLRequest(url: url)
        request.setValue("DisneyWaitTimes/1.0 (tvOS)", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 8

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw ServiceError.message("No HTTP response from server.")
        }

        guard http.statusCode == 200 else {
            let body = String(data: data, encoding: .utf8) ?? ""
            let snippet = body.prefix(180).trimmingCharacters(in: .whitespacesAndNewlines)
            throw ServiceError.message("HTTP \(http.statusCode) from API. \(snippet)")
        }

        do {
            let decoded = try JSONDecoder().decode(LiveDataResponse.self, from: data)
            return decoded.liveData
                .filter { $0.entityType == "ATTRACTION" }
                .map { item in
                    Ride(
                        id: item.id,
                        name: item.name,
                        status: item.status ?? .closed,
                        waitMinutes: item.queue?.STANDBY?.waitTime,
                        singleRiderWait: item.queue?.SINGLE_RIDER?.waitTime
                    )
                }
                .sorted { lhs, rhs in
                    if lhs.isOperating != rhs.isOperating { return lhs.isOperating }
                    let l = lhs.waitMinutes ?? -1
                    let r = rhs.waitMinutes ?? -1
                    return l > r
                }
        } catch {
            throw ServiceError.message("Couldn't read API response: \(error.localizedDescription)")
        }
    }

    enum ServiceError: LocalizedError {
        case message(String)
        var errorDescription: String? {
            switch self {
            case .message(let m): return m
            }
        }
    }
}
