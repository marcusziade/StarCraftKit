import Foundation

protocol StarCraftScoreable {
    var baseURL: URL { get }

    /// Fetches all listed professional players for StarCraft II. This includes both active and inactive players. The list is not exhaustive and may not include all players. The list is paginated and may require multiple requests to retrieve all players.
    /// - Returns: A ``PlayersResponse`` instance containing interface methods for filtering and grouping players.
    func allPlayers(page: Int, perPage: Int) async throws -> PlayersResponse
    /// Fetches all listed tournaments for StarCraft II. The list is paginated and may require multiple requests to retrieve all tournaments. This includes past, ongoing, and upcoming tournaments. The list is not exhaustive and may not include all tournaments.
    /// - Returns: A ``TournamentsResponse`` instance containing interface methods for filtering and grouping tournaments.
    func allTournaments(page: Int, perPage: Int) async throws -> TournamentsResponse
    /// Fetches all listed matches for StarCraft II. The list is paginated and may require multiple requests to retrieve all matches. This includes past, ongoing, and upcoming matches. The list is not exhaustive and may not include all matches.
    /// - Returns: A ``MatchResponse`` instance containing interface methods for filtering and grouping matches.
    func allMatches(page: Int, perPage: Int) async throws -> MatchResponse
}

public final class StarCraftAPI: StarCraftScoreable {
    let baseURL = URL(string: "https://api.pandascore.co/starcraft-2/")!

    public init(token: String, urlSession: URLSession = .shared) {
        self.token = token
        self.urlSession = urlSession
    }

    public func allPlayers(page: Int = 1, perPage: Int = 50) async throws -> PlayersResponse {
        PlayersResponse(
            players: try await fetchData(
                endpoint: StarCraft2Endpoint.players.path,
                page: page,
                perPage: perPage
            )
        )
    }

    public func allTournaments(page: Int = 1, perPage: Int = 50) async throws -> TournamentsResponse {
        TournamentsResponse(tournaments: try await fetchData(
            endpoint: StarCraft2Endpoint.allTournaments.path,
            page: page,
            perPage: perPage
        ))
    }

    public func allMatches(page: Int = 1, perPage: Int = 50) async throws -> MatchResponse {
        MatchResponse(matches: try await fetchData(
            endpoint: StarCraft2Endpoint.allMatches.path,
            page: page,
            perPage: perPage
        ))
    }

    // MARK: - Private

    private let token: String
    private let urlSession: URLSession

    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

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
        return try jsonDecoder.decode(T.self, from: data)
    }

    private func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        return request
    }
}
