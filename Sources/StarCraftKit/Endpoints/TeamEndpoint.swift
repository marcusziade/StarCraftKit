import Foundation

/// Endpoint for team operations
public enum TeamEndpoint: Endpoint {
    case all
    
    public static var basePath: String {
        "/starcraft-2/teams"
    }
    
    public var subPath: String? {
        nil
    }
}

/// API request for fetching teams
public struct TeamsRequest: APIRequest {
    public typealias Response = [Team]
    
    public let queryParameters: [String: Any]
    
    public var path: String {
        TeamEndpoint.all.fullPath
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
        location: String? = nil
    ) {
        var parameters = QueryParameters(
            pagination: PaginationParameters(page: page, size: pageSize),
            sort: sort,
            filters: filters,
            search: search
        )
        
        if let location = location {
            if parameters.filters == nil {
                parameters.filters = [:]
            }
            parameters.filters?["location"] = location
        }
        
        self.queryParameters = parameters.toDictionary()
    }
}

// MARK: - Convenience Factory Methods
public extension TeamsRequest {
    /// Search for teams by name
    static func searchByName(
        _ name: String,
        page: Int = 1,
        pageSize: Int = 50
    ) -> TeamsRequest {
        TeamsRequest(
            page: page,
            pageSize: pageSize,
            search: ["name": name]
        )
    }
    
    /// Get teams by location
    static func byLocation(
        _ location: String,
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil
    ) -> TeamsRequest {
        TeamsRequest(
            page: page,
            pageSize: pageSize,
            sort: sort,
            location: location
        )
    }
    
    /// Get teams sorted alphabetically
    static func alphabetical(
        page: Int = 1,
        pageSize: Int = 50
    ) -> TeamsRequest {
        TeamsRequest(
            page: page,
            pageSize: pageSize,
            sort: [SortParameter(field: "name", direction: .ascending)]
        )
    }
}