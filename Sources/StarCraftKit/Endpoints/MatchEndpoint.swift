import Foundation

/// Endpoint for match operations
public enum MatchEndpoint: Endpoint {
    case all
    case past
    case running
    case upcoming
    
    public static var basePath: String {
        "/starcraft-2/matches"
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

/// API request for fetching matches
public struct MatchesRequest: APIRequest {
    public typealias Response = [Match]
    
    public let endpoint: MatchEndpoint
    public let queryParameters: [String: Any]
    
    public var path: String {
        endpoint.fullPath
    }
    
    public init(
        endpoint: MatchEndpoint = .all,
        parameters: QueryParameters = QueryParameters()
    ) {
        self.endpoint = endpoint
        self.queryParameters = parameters.toDictionary()
    }
    
    public init(
        endpoint: MatchEndpoint = .all,
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil,
        filters: [String: Any]? = nil,
        search: [String: String]? = nil,
        opponentID: Int? = nil,
        tournamentID: Int? = nil,
        serieID: Int? = nil,
        leagueID: Int? = nil
    ) {
        self.endpoint = endpoint
        
        var parameters = QueryParameters(
            pagination: PaginationParameters(page: page, size: pageSize),
            sort: sort,
            filters: filters,
            search: search
        )
        
        if let opponentID = opponentID {
            if parameters.filters == nil {
                parameters.filters = [:]
            }
            parameters.filters?["opponent_id"] = opponentID
        }
        
        if let tournamentID = tournamentID {
            if parameters.filters == nil {
                parameters.filters = [:]
            }
            parameters.filters?["tournament_id"] = tournamentID
        }
        
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
        
        self.queryParameters = parameters.toDictionary()
    }
}

// MARK: - Convenience Factory Methods
public extension MatchesRequest {
    /// Request for past matches
    static func past(
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil
    ) -> MatchesRequest {
        MatchesRequest(
            endpoint: .past,
            page: page,
            pageSize: pageSize,
            sort: sort
        )
    }
    
    /// Request for running matches
    static func running(
        page: Int = 1,
        pageSize: Int = 50
    ) -> MatchesRequest {
        MatchesRequest(
            endpoint: .running,
            page: page,
            pageSize: pageSize
        )
    }
    
    /// Request for upcoming matches
    static func upcoming(
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil
    ) -> MatchesRequest {
        MatchesRequest(
            endpoint: .upcoming,
            page: page,
            pageSize: pageSize,
            sort: sort ?? [SortParameter(field: "begin_at", direction: .ascending)]
        )
    }
}