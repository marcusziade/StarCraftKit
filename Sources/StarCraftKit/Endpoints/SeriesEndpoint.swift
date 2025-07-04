import Foundation

/// Endpoint for series operations
public enum SeriesEndpoint: Endpoint {
    case all
    case past
    case running
    case upcoming
    
    public static var basePath: String {
        "/starcraft-2/series"
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

/// API request for fetching series
public struct SeriesRequest: APIRequest {
    public typealias Response = [Series]
    
    public let endpoint: SeriesEndpoint
    public let queryParameters: [String: Any]
    
    public var path: String {
        endpoint.fullPath
    }
    
    public init(
        endpoint: SeriesEndpoint = .all,
        parameters: QueryParameters = QueryParameters()
    ) {
        self.endpoint = endpoint
        self.queryParameters = parameters.toDictionary()
    }
    
    public init(
        endpoint: SeriesEndpoint = .all,
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil,
        filters: [String: Any]? = nil,
        search: [String: String]? = nil,
        leagueID: Int? = nil,
        year: Int? = nil
    ) {
        self.endpoint = endpoint
        
        var parameters = QueryParameters(
            pagination: PaginationParameters(page: page, size: pageSize),
            sort: sort,
            filters: filters,
            search: search
        )
        
        if let leagueID = leagueID {
            if parameters.filters == nil {
                parameters.filters = [:]
            }
            parameters.filters?["league_id"] = leagueID
        }
        
        if let year = year {
            if parameters.filters == nil {
                parameters.filters = [:]
            }
            parameters.filters?["year"] = year
        }
        
        self.queryParameters = parameters.toDictionary()
    }
}

// MARK: - Convenience Factory Methods
public extension SeriesRequest {
    /// Request for past series
    static func past(
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil
    ) -> SeriesRequest {
        SeriesRequest(
            endpoint: .past,
            page: page,
            pageSize: pageSize,
            sort: sort ?? [SortParameter(field: "end_at", direction: .descending)]
        )
    }
    
    /// Request for running series
    static func running(
        page: Int = 1,
        pageSize: Int = 50
    ) -> SeriesRequest {
        SeriesRequest(
            endpoint: .running,
            page: page,
            pageSize: pageSize
        )
    }
    
    /// Request for upcoming series
    static func upcoming(
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil
    ) -> SeriesRequest {
        SeriesRequest(
            endpoint: .upcoming,
            page: page,
            pageSize: pageSize,
            sort: sort ?? [SortParameter(field: "begin_at", direction: .ascending)]
        )
    }
    
    /// Get series by year
    static func byYear(
        _ year: Int,
        page: Int = 1,
        pageSize: Int = 50,
        sort: [SortParameter]? = nil
    ) -> SeriesRequest {
        SeriesRequest(
            page: page,
            pageSize: pageSize,
            sort: sort,
            year: year
        )
    }
}