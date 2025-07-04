import Foundation

/// Protocol defining an API endpoint
public protocol Endpoint: Sendable {
    /// The base path for this endpoint
    static var basePath: String { get }
    
    /// Available sub-endpoints (e.g., past, running, upcoming)
    var subPath: String? { get }
    
    /// Build the full path for this endpoint
    var fullPath: String { get }
}

/// Default implementation
public extension Endpoint {
    var fullPath: String {
        if let subPath = subPath {
            return "\(Self.basePath)/\(subPath)"
        }
        return Self.basePath
    }
}

/// Protocol for endpoints that support temporal filtering
public protocol TemporalEndpoint: Endpoint {
    /// Get past items
    static var past: Self { get }
    
    /// Get currently running items
    static var running: Self { get }
    
    /// Get upcoming items
    static var upcoming: Self { get }
}