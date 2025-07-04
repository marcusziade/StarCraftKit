import Foundation

/// Endpoint for player operations
public enum PlayerEndpoint: Endpoint {
    case all
    
    public static var basePath: String {
        "/starcraft-2/players"
    }
    
    public var subPath: String? {
        nil
    }
}

/// API request for fetching players
public struct PlayersRequest: APIRequest {
    public typealias Response = [Player]
    
    public let queryParameters: [String: Any]
    
    public var path: String {
        PlayerEndpoint.all.fullPath
    }
    
    public init(parameters: QueryParameters = QueryParameters()) {
        self.queryParameters = parameters.toDictionary()
    }
    
    public init(
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil,
        filters: [String: Any]? = nil,
        search: [String: String]? = nil,
        nationality: String? = nil,
        teamID: Int? = nil
    ) {
        var parameters = QueryParameters(
            pagination: PaginationParameters(page: page, size: pageSize),
            sort: sort,
            filters: filters,
            search: search
        )
        
        if let nationality = nationality {
            if parameters.filters == nil {
                parameters.filters = [:]
            }
            parameters.filters?["nationality"] = nationality
        }
        
        if let teamID = teamID {
            if parameters.filters == nil {
                parameters.filters = [:]
            }
            parameters.filters?["current_team_id"] = teamID
        }
        
        self.queryParameters = parameters.toDictionary()
    }
}

// MARK: - Convenience Factory Methods
public extension PlayersRequest {
    /// Search for players by name
    static func searchByName(
        _ name: String,
        page: Int = 1,
        pageSize: Int = 50
    ) -> PlayersRequest {
        PlayersRequest(
            page: page,
            pageSize: pageSize,
            search: ["name": name]
        )
    }
    
    /// Get players by nationality
    static func byNationality(
        _ nationality: String,
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil
    ) -> PlayersRequest {
        PlayersRequest(
            page: page,
            pageSize: pageSize,
            sort: sort,
            nationality: nationality
        )
    }
    
    /// Get players by team
    static func byTeam(
        _ teamID: Int,
        page: Int = 1,
        pageSize: Int = 50
    ) -> PlayersRequest {
        PlayersRequest(
            page: page,
            pageSize: pageSize,
            teamID: teamID
        )
    }
}