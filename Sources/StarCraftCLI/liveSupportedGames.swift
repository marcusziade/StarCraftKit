import Foundation

func liveSupportedTournaments() async {
    do {
        let response = try await api.allTournaments()
        let liveSupported = response.liveSupportedTournaments
        print("Fetched \(liveSupported.count) tournaments with live support")
    } catch {
        print("Failed to fetch live supported tournaments: \(error)")
    }
}
