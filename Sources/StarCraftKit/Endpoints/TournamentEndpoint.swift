import Foundation

/// Endpoint for tournament operations
public enum TournamentEndpoint: Endpoint {
    case all
    case past
    case running
    case upcoming
    
    public static var basePath: String {
        "/starcraft-2/tournaments"
    }
    
    public var subPath: String? {
        switch self {
        case .all:
            return nil
        case .past:
            return "past"
        case .running:
            return "running"
        case .upcoming:
            return "upcoming"
        }
    }
}

/// API request for fetching tournaments
public struct TournamentsRequest: APIRequest {
    public typealias Response = [Tournament]
    
    public let endpoint: TournamentEndpoint
    public let queryParameters: [String: Any]
    
    public var path: String {
        endpoint.fullPath
    }
    
    public init(
        endpoint: TournamentEndpoint = .all,
        parameters: QueryParameters = QueryParameters()
    ) {
        self.endpoint = endpoint
        self.queryParameters = parameters.toDictionary()
    }
    
    public init(
        endpoint: TournamentEndpoint = .all,
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil,
        filters: [String: Any]? = nil,
        search: [String: String]? = nil,
        serieID: Int? = nil,
        leagueID: Int? = nil,
        tier: String? = nil
    ) {
        self.endpoint = endpoint
        
        var parameters = QueryParameters(
            pagination: PaginationParameters(page: page, size: pageSize),
            sort: sort,
            filters: filters,
            search: search
        )
        
        if let serieID = serieID {
            if parameters.filters == nil {
                parameters.filters = [:]
            }
            parameters.filters?["serie_id"] = serieID
        }
        
        if let leagueID = leagueID {
            if parameters.filters == nil {
                parameters.filters = [:]
            }
            parameters.filters?["league_id"] = leagueID
        }
        
        if let tier = tier {
            if parameters.filters == nil {
                parameters.filters = [:]
            }
            parameters.filters?["tier"] = tier
        }
        
        self.queryParameters = parameters.toDictionary()
    }
}

// MARK: - Convenience Factory Methods
public extension TournamentsRequest {
    /// Request for past tournaments
    static func past(
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil
    ) -> TournamentsRequest {
        TournamentsRequest(
            endpoint: .past,
            page: page,
            pageSize: pageSize,
            sort: sort ?? [SortParameter(field: "end_at", direction: .descending)]
        )
    }
    
    /// Request for running tournaments
    static func running(
        page: Int = 1,
        pageSize: Int = 50
    ) -> TournamentsRequest {
        TournamentsRequest(
            endpoint: .running,
            page: page,
            pageSize: pageSize
        )
    }
    
    /// Request for upcoming tournaments
    static func upcoming(
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil
    ) -> TournamentsRequest {
        TournamentsRequest(
            endpoint: .upcoming,
            page: page,
            pageSize: pageSize,
            sort: sort ?? [SortParameter(field: "begin_at", direction: .ascending)]
        )
    }
    
    /// Get tournaments with prize pools
    static func withPrizePools(
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil
    ) -> TournamentsRequest {
        TournamentsRequest(
            page: page,
            pageSize: pageSize,
            sort: sort,
            filters: ["has_prizepool": true]
        )
    }
}