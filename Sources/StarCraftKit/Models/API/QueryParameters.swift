import Foundation

/// Query parameters for API requests
public struct QueryParameters: Sendable {
    /// Pagination parameters
    public var pagination: PaginationParameters?
    
    /// Sort parameters
    public var sort: [SortParameter]?
    
    /// Filter parameters
    public var filters: [String: Any]?
    
    /// Search parameters
    public var search: [String: String]?
    
    /// Range parameters
    public var ranges: [String: RangeParameter]?
    
    public init(
        pagination: PaginationParameters? = nil,
        sort: [SortParameter]? = nil,
        filters: [String: Any]? = nil,
        search: [String: String]? = nil,
        ranges: [String: RangeParameter]? = nil
    ) {
        self.pagination = pagination
        self.sort = sort
        self.filters = filters
        self.search = search
        self.ranges = ranges
    }
    
    /// Convert to dictionary for URL query items
    public func toDictionary() -> [String: Any] {
        var params: [String: Any] = [:]
        
        if let pagination = pagination {
            params["page[number]"] = pagination.page
            params["page[size]"] = pagination.size
        }
        
        if let sort = sort, !sort.isEmpty {
            params["sort"] = sort.map { $0.toString() }.joined(separator: ",")
        }
        
        if let filters = filters {
            for (key, value) in filters {
                params["filter[\(key)]"] = value
            }
        }
        
        if let search = search {
            for (key, value) in search {
                params["search[\(key)]"] = value
            }
        }
        
        if let ranges = ranges {
            for (key, range) in ranges {
                params["range[\(key)]"] = range.toString()
            }
        }
        
        return params
    }
}

/// Pagination parameters
public struct PaginationParameters: Sendable {
    /// Page number (1-based)
    public let page: Int
    
    /// Number of items per page
    public let size: Int
    
    public init(page: Int = 1, size: Int = 50) {
        self.page = max(1, page)
        self.size = min(100, max(1, size))
    }
}

/// Sort parameter
public struct SortParameter: Sendable {
    /// Field to sort by
    public let field: String
    
    /// Sort direction
    public let direction: SortDirection
    
    public init(field: String, direction: SortDirection = .ascending) {
        self.field = field
        self.direction = direction
    }
    
    /// Convert to string representation
    public func toString() -> String {
        switch direction {
        case .ascending:
            return field
        case .descending:
            return "-\(field)"
        }
    }
}

/// Sort direction
public enum SortDirection: Sendable {
    case ascending
    case descending
}

/// Range parameter for numeric filtering
public struct RangeParameter: Sendable {
    /// Minimum value (inclusive)
    public let min: Double?
    
    /// Maximum value (inclusive)
    public let max: Double?
    
    public init(min: Double? = nil, max: Double? = nil) {
        self.min = min
        self.max = max
    }
    
    /// Convert to string representation
    public func toString() -> String {
        switch (min, max) {
        case (let min?, let max?):
            return "\(min),\(max)"
        case (let min?, nil):
            return "\(min),"
        case (nil, let max?):
            return ",\(max)"
        default:
            return ""
        }
    }
}

// MARK: - Builder Pattern
public extension QueryParameters {
    /// Builder for query parameters
    class Builder {
        private var parameters = QueryParameters()
        
        public init() {}
        
        @discardableResult
        public func withPagination(page: Int, size: Int = 50) -> Builder {
            parameters.pagination = PaginationParameters(page: page, size: size)
            return self
        }
        
        @discardableResult
        public func withSort(_ field: String, direction: SortDirection = .ascending) -> Builder {
            if parameters.sort == nil {
                parameters.sort = []
            }
            parameters.sort?.append(SortParameter(field: field, direction: direction))
            return self
        }
        
        @discardableResult
        public func withFilter(_ key: String, value: Any) -> Builder {
            if parameters.filters == nil {
                parameters.filters = [:]
            }
            parameters.filters?[key] = value
            return self
        }
        
        @discardableResult
        public func withSearch(_ key: String, value: String) -> Builder {
            if parameters.search == nil {
                parameters.search = [:]
            }
            parameters.search?[key] = value
            return self
        }
        
        @discardableResult
        public func withRange(_ key: String, min: Double? = nil, max: Double? = nil) -> Builder {
            if parameters.ranges == nil {
                parameters.ranges = [:]
            }
            parameters.ranges?[key] = RangeParameter(min: min, max: max)
            return self
        }
        
        public func build() -> QueryParameters {
            return parameters
        }
    }
}