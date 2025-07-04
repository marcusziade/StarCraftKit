import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// Core networking client for API communication
public actor NetworkingClient: Sendable {
    private let session: URLSession
    private let logger: Logger
    private let baseURL: URL
    private let defaultHeaders: [String: String]
    
    /// Rate limit tracking
    private var rateLimitRemaining: Int?
    private var rateLimitResetTime: Date?
    
    public init(
        baseURL: URL,
        session: URLSession = .shared,
        defaultHeaders: [String: String] = [:],
        logger: Logger = Logger(label: "StarCraftKit.NetworkingClient")
    ) {
        self.baseURL = baseURL
        self.session = session
        self.defaultHeaders = defaultHeaders
        self.logger = logger
    }
    
    /// Execute a network request
    public func execute<T: Decodable>(
        _ request: URLRequest,
        responseType: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> (data: T, headers: [String: String]) {
        logger.debug("Executing request: \(request.url?.absoluteString ?? "unknown")")
        
        #if canImport(FoundationNetworking)
        // Linux implementation
        let (data, response): (Data, URLResponse) = try await withCheckedThrowingContinuation { continuation in
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                }
            }
            task.resume()
        }
        #else
        // Apple platforms
        let (data, response) = try await session.data(for: request)
        #endif
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError(underlying: URLError(.badServerResponse))
        }
        
        updateRateLimitInfo(from: httpResponse)
        
        let headers = httpResponse.allHeaderFields.reduce(into: [String: String]()) { result, header in
            if let key = header.key as? String, let value = header.value as? String {
                result[key] = value
            }
        }
        
        try validateResponse(httpResponse, data: data)
        
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return (decodedData, headers)
        } catch {
            logger.error("Decoding error: \(error), data: \(String(data: data, encoding: .utf8) ?? "unable to decode")")
            throw APIError.decodingError(underlying: error, data: data)
        }
    }
    
    /// Build URLRequest from components
    public func buildRequest(
        path: String,
        method: HTTPMethod,
        queryParameters: [String: Any] = [:],
        headers: [String: String] = [:],
        body: Data? = nil
    ) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw APIError.invalidRequest(reason: "Invalid path: \(path)")
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if !queryParameters.isEmpty {
            var queryItems: [URLQueryItem] = []
            for (key, value) in queryParameters {
                if let arrayValue = value as? [Any] {
                    for item in arrayValue {
                        queryItems.append(URLQueryItem(name: key, value: String(describing: item)))
                    }
                } else {
                    queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
                }
            }
            components?.queryItems = queryItems
        }
        
        guard let finalURL = components?.url else {
            throw APIError.invalidRequest(reason: "Failed to build URL")
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        for (key, value) in defaultHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil && body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    /// Get current rate limit status
    public func getRateLimitStatus() -> (remaining: Int?, resetTime: Date?) {
        return (rateLimitRemaining, rateLimitResetTime)
    }
    
    private func updateRateLimitInfo(from response: HTTPURLResponse) {
        if let remainingString = response.value(forHTTPHeaderField: "X-Rate-Limit-Remaining"),
           let remaining = Int(remainingString) {
            rateLimitRemaining = remaining
        }
        
        if let resetString = response.value(forHTTPHeaderField: "X-Rate-Limit-Reset"),
           let resetTimestamp = TimeInterval(resetString) {
            rateLimitResetTime = Date(timeIntervalSince1970: resetTimestamp)
        }
    }
    
    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 400:
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            throw APIError.httpError(statusCode: 400, response: errorResponse)
        case 401:
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            throw APIError.unauthorized(message: errorResponse?.message ?? "Invalid authentication token")
        case 403:
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            throw APIError.forbidden(message: errorResponse?.message ?? "Plan does not support requested URL")
        case 404:
            throw APIError.notFound(resource: response.url?.absoluteString ?? "unknown")
        case 429:
            let retryAfter = response.value(forHTTPHeaderField: "Retry-After").flatMap(TimeInterval.init)
            let remaining = response.value(forHTTPHeaderField: "X-Rate-Limit-Remaining").flatMap(Int.init)
            throw APIError.rateLimitExceeded(retryAfter: retryAfter, remaining: remaining)
        case 500...599:
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            throw APIError.serverError(statusCode: response.statusCode, message: errorResponse?.message)
        default:
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            throw APIError.httpError(statusCode: response.statusCode, response: errorResponse)
        }
    }
}