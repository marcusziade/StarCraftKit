import Foundation

func ongoingTournaments() async {
    do {
        let response = try await api.allTournaments()
        let ongoing = response.ongoingTournaments
        print("Fetched \(ongoing.count) ongoing tournaments")
    } catch {
        print("Failed to fetch ongoing tournaments: \(error)")
    }
}
