import Foundation

protocol StarCraftScoreable {
    var baseURL: URL { get }

    /// Fetches all listed professional players for StarCraft II. This includes both active and inactive players. The list is not exhaustive and may not include all players. The list is paginated and may require multiple requests to retrieve all players.
    func allPlayers(page: Int, perPage: Int) async throws -> [Player]
    /// Fetches all listed tournaments for StarCraft II. The list is paginated and may require multiple requests to retrieve all tournaments. This includes past, ongoing, and upcoming tournaments. The list is not exhaustive and may not include all tournaments.
    func allTournaments(page: Int, perPage: Int) async throws -> [Tournament]
    /// Fetches all listed matches for StarCraft II. The list is paginated and may require multiple requests to retrieve all matches. This includes past, ongoing, and upcoming matches. The list is not exhaustive and may not include all matches.
    func allMatches(page: Int, perPage: Int) async throws -> [Match]
}

public final class StarCraftAPI: StarCraftScoreable {
    let baseURL = URL(string: "https://api.pandascore.co/starcraft-2/")!

    public init(token: String, urlSession: URLSession = .shared) {
        self.token = token
        self.urlSession = urlSession
    }

    public func allPlayers(page: Int = 1, perPage: Int = 50) async throws -> [Player] {
        try await fetchData(endpoint: StarCraft2Endpoint.players.path, page: page, perPage: perPage)
    }

    public func allTournaments(page: Int = 1, perPage: Int = 50) async throws -> [Tournament] {
        try await fetchData(
            endpoint: StarCraft2Endpoint.allTournaments.path,
            page: page,
            perPage: perPage
        )
    }

    public func allMatches(page: Int = 1, perPage: Int = 50) async throws -> [Match] {
        try await fetchData(
            endpoint: StarCraft2Endpoint.allMatches.path,
            page: page,
            perPage: perPage
        )
    }

    // MARK: - Private

    private let token: String
    private let urlSession: URLSession

    private func fetchData<T: Decodable>(
        endpoint: String,
        page: Int = 1,
        perPage: Int = 50
    ) async throws -> T {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(endpoint),
            resolvingAgainstBaseURL: true
        )
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage)),
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

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
