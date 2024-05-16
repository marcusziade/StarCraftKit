import Foundation

func ongoingMatches() async {
    do {
        let response = try await api.allMatches()
        let ongoingMatches = response.ongoingMatches
        print("Fetched \(ongoingMatches.count) ongoing matches")
    } catch {
        print("Failed to fetch ongoing matches: \(error)")
    }
}
