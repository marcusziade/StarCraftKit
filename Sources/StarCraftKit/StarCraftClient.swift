import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// The main client for interacting with the PandaScore StarCraft II API.
///
/// `StarCraftClient` is an actor that provides thread-safe access to all StarCraft II esports data.
/// It handles authentication, caching, retry logic, and all API communications.
///
/// ## Creating a Client
///
/// ```swift
/// // Basic initialization
/// let client = StarCraftClient(apiToken: "your-api-token")
///
/// // Custom configuration
/// let config = StarCraftClient.Configuration(
///     apiKey: "your-api-token",
///     retryConfiguration: .aggressive,
///     cacheConfiguration: .init(maxSize: 200, defaultTTL: 600)
/// )
/// let client = StarCraftClient(configuration: config)
/// ```
///
/// ## Making Requests
///
/// All methods are async and throw errors:
///
/// ```swift
/// do {
///     let matches = try await client.getLiveMatches()
///     let players = try await client.getPlayers()
/// } catch {
///     print("Error: \(error)")
/// }
/// ```
///
/// ## Topics
///
/// ### Matches
/// - ``getLiveMatches()``
/// - ``getUpcomingMatches()``
/// - ``getPastMatches()``
/// - ``getMatches(parameters:)``
///
/// ### Players
/// - ``getPlayers(parameters:)``
/// - ``getPlayer(id:)``
///
/// ### Teams
/// - ``getTeams(parameters:)``
/// - ``getTeam(id:)``
///
/// ### Tournaments
/// - ``getTournaments(parameters:)``
/// - ``getTournament(id:)``
/// - ``getTournamentMatches(tournamentId:parameters:)``
public actor StarCraftClient: APIClientProtocol {
    private let networkingClient: NetworkingClient
    private let cache: ResponseCache
    private let retryHandler: RetryHandler
    private let logger: Logger
    private let decoder: JSONDecoder
    
    /// Configuration options for the StarCraft client.
    ///
    /// Use this to customize authentication, caching, retry behavior, and more.
    ///
    /// ```swift
    /// let config = Configuration(
    ///     apiKey: "your-token",
    ///     authMethod: .bearerToken,
    ///     retryConfiguration: .aggressive,
    ///     cacheConfiguration: .init(maxSize: 200, defaultTTL: 600)
    /// )
    /// ```
    public struct Configuration: Sendable {
        public let apiKey: String
        public let authMethod: AuthMethod
        public let baseURL: URL
        public let retryConfiguration: RetryConfiguration
        public let cacheConfiguration: CacheConfiguration
        
        public enum AuthMethod: Sendable {
            case bearerToken
            case queryParameter
        }
        
        public struct CacheConfiguration: Sendable {
            public let maxSize: Int
            public let defaultTTL: TimeInterval
            
            public init(maxSize: Int = 100, defaultTTL: TimeInterval = 300) {
                self.maxSize = maxSize
                self.defaultTTL = defaultTTL
            }
        }
        
        public init(
            apiKey: String,
            authMethod: AuthMethod = .bearerToken,
            baseURL: URL = URL(string: "https://api.pandascore.co")!,
            retryConfiguration: RetryConfiguration = .default,
            cacheConfiguration: CacheConfiguration = CacheConfiguration()
        ) {
            self.apiKey = apiKey
            self.authMethod = authMethod
            self.baseURL = baseURL
            self.retryConfiguration = retryConfiguration
            self.cacheConfiguration = cacheConfiguration
        }
    }
    
    private let configuration: Configuration
    
    /// Initialize a new StarCraft API client
    public init(configuration: Configuration) {
        self.configuration = configuration
        self.logger = Logger(label: "StarCraftKit.Client")
        
        var defaultHeaders: [String: String] = [:]
        if configuration.authMethod == .bearerToken {
            defaultHeaders["Authorization"] = "Bearer \(configuration.apiKey)"
        }
        
        self.networkingClient = NetworkingClient(
            baseURL: configuration.baseURL,
            defaultHeaders: defaultHeaders,
            logger: Logger(label: "StarCraftKit.NetworkingClient")
        )
        
        self.cache = ResponseCache(
            maxCacheSize: configuration.cacheConfiguration.maxSize,
            logger: Logger(label: "StarCraftKit.Cache")
        )
        
        self.retryHandler = RetryHandler(
            configuration: configuration.retryConfiguration,
            logger: Logger(label: "StarCraftKit.RetryHandler")
        )
        
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .pandaScore
    }
    
    /// Execute an API request
    public func execute<T: Decodable>(_ request: any APIRequest) async throws -> T {
        let cacheKey = buildCacheKey(for: request)
        
        if request.cachePolicy != .noCache {
            if let cached: (data: T, headers: [String: String]) = try await cache.get(
                for: cacheKey,
                type: T.self,
                decoder: decoder
            ) {
                return cached.data
            }
        }
        
        var queryParams = request.queryParameters
        if configuration.authMethod == .queryParameter {
            queryParams["token"] = configuration.apiKey
        }
        
        let urlRequest = try await networkingClient.buildRequest(
            path: request.path,
            method: request.method,
            queryParameters: queryParams,
            headers: request.headers,
            body: request.body
        )
        
        let (data, headers): (T, [String: String]) = try await retryHandler.executeRequest(
            client: networkingClient,
            request: urlRequest,
            responseType: T.self,
            decoder: decoder
        )
        
        // Note: We can't cache generic Decodable types without Encodable conformance
        // This is a limitation of the cache system
        
        return data
    }
    
    /// Execute a paginated request and return all pages
    public func executePaginated<T: Decodable>(_ request: any APIRequest, maxPages: Int? = nil) async throws -> [T] {
        var allItems: [T] = []
        var currentPage = 1
        var hasMorePages = true
        let pageSize = request.queryParameters["page[size]"] as? Int ?? 50
        
        while hasMorePages && (maxPages == nil || currentPage <= maxPages!) {
            // Create a new request with updated page number
            var params = request.queryParameters
            params["page[number]"] = currentPage
            
            let urlRequest = try await networkingClient.buildRequest(
                path: request.path,
                method: request.method,
                queryParameters: params,
                headers: request.headers,
                body: request.body
            )
            
            let (response, _): ([T], [String: String]) = try await retryHandler.executeRequest(
                client: networkingClient,
                request: urlRequest,
                responseType: [T].self,
                decoder: decoder
            )
            
            allItems.append(contentsOf: response)
            
            hasMorePages = response.count >= pageSize
            currentPage += 1
        }
        
        return allItems
    }
    
    /// Stream live data (WebSocket)
    public nonisolated func stream<T: Decodable>(_ request: any StreamingRequest) -> AsyncThrowingStream<T, Error> {
        // WebSocket streaming requires URLSessionWebSocketTask which is not available on Linux
        return AsyncThrowingStream { continuation in
            continuation.finish(throwing: APIError.webSocketError(reason: "WebSocket streaming is only available on Apple platforms"))
        }
    }
    
    /// Get rate limit status
    public func getRateLimitStatus() async -> (remaining: Int?, resetTime: Date?) {
        await networkingClient.getRateLimitStatus()
    }
    
    /// Clear response cache
    public func clearCache() async {
        await cache.clearAll()
    }
    
    /// Get cache statistics
    public func getCacheStatistics() async -> CacheStatistics {
        await cache.getStatistics()
    }
    
    private func buildCacheKey(for request: any APIRequest) -> String {
        var components = [request.path]
        
        let sortedParams = request.queryParameters.sorted { $0.key < $1.key }
        for (key, value) in sortedParams {
            components.append("\(key)=\(value)")
        }
        
        return components.joined(separator: "&")
    }
}

// MARK: - Convenience Methods
public extension StarCraftClient {
    /// Fetch leagues
    func getLeagues(_ request: LeaguesRequest = LeaguesRequest()) async throws -> [League] {
        try await execute(request)
    }
    
    /// Fetch all leagues (all pages)
    func getAllLeagues() async throws -> [League] {
        try await executePaginated(LeaguesRequest(), maxPages: nil)
    }
    
    /// Fetch matches
    func getMatches(_ request: MatchesRequest = MatchesRequest()) async throws -> [Match] {
        try await execute(request)
    }
    
    /// Fetch players
    func getPlayers(_ request: PlayersRequest = PlayersRequest()) async throws -> [Player] {
        try await execute(request)
    }
    
    /// Fetch teams
    func getTeams(_ request: TeamsRequest = TeamsRequest()) async throws -> [Team] {
        try await execute(request)
    }
    
    /// Fetch series
    func getSeries(_ request: SeriesRequest = SeriesRequest()) async throws -> [Series] {
        try await execute(request)
    }
    
    /// Fetch tournaments
    func getTournaments(_ request: TournamentsRequest = TournamentsRequest()) async throws -> [Tournament] {
        try await execute(request)
    }
    
    /// Fetch live matches
    func getLiveMatches() async throws -> [Match] {
        try await getMatches(.running())
    }
    
    /// Fetch upcoming matches
    func getUpcomingMatches() async throws -> [Match] {
        try await getMatches(.upcoming())
    }
    
    /// Search for players by name
    func searchPlayers(name: String) async throws -> [Player] {
        try await getPlayers(.searchByName(name))
    }
    
    /// Search for teams by name
    func searchTeams(name: String) async throws -> [Team] {
        try await getTeams(.searchByName(name))
    }
}