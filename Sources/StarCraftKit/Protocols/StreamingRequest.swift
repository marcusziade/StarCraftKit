import Foundation

/// Protocol defining a streaming request (WebSocket)
public protocol StreamingRequest: Sendable {
    /// The response type expected from this stream
    associatedtype Response: Decodable
    
    /// The WebSocket URL path
    var path: String { get }
    
    /// Query parameters (including authentication token)
    var queryParameters: [String: String] { get }
    
    /// The feed types to subscribe to
    var feeds: [StreamFeed] { get }
}

/// Available stream feed types
public enum StreamFeed: String, Sendable, CaseIterable {
    case frames
    case events
}