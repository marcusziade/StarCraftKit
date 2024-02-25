import Foundation

protocol StarCraftScoreable {
    var baseURL: URL { get }

    func allPlayers() async throws -> [Player]
    func allTournaments() async throws -> [Tournament]
    func allMatches() async throws -> [Match]
}

public final class StarCraftAPI: StarCraftScoreable {
    let baseURL = URL(string: "https://api.pandascore.co/starcraft-2/")!

    public init(token: String, urlSession: URLSession = .shared) {
        self.token = token
        self.urlSession = urlSession
    }

    public func allPlayers() async throws -> [Player] {
        try await fetchData(endpoint: StarCraft2Endpoint.players.path)
    }

    public func allTournaments() async throws -> [Tournament] {
        try await fetchData(endpoint: StarCraft2Endpoint.allTournaments.path)
    }

    public func allMatches() async throws -> [Match] {
        try await fetchData(endpoint: StarCraft2Endpoint.allMatches.path)
    }

    // MARK: - Private

    private let token: String
    private let urlSession: URLSession

    private func fetchData<T: Decodable>(endpoint: String) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint)
        let request = createRequest(url: url)
        let (data, response) = try await urlSession.data(for: request)
        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw PandaScoreAPIError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        return request
    }
}
