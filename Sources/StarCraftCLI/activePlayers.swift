import Foundation

func activePlayers() async {
    do {
        let response = try await api.allPlayers().activePlayers
        print("Fetched active players:\n\(response.map(\.name))")
    } catch {
        print("Failed to fetch active players \(error)")
    }
}
