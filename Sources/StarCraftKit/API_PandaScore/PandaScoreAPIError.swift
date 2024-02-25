import Foundation

/// An error type that represents errors that can occur when interacting with the PandaScore API.
public enum PandaScoreAPIError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed
    case invalidData
    /// The REST API sets a rate limit of 1000 requests per hours.
    case rateLimitExceeded
    case unauthorized
    case forbidden
    case notFound
    case badRequest

    init(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 429:
            self = .rateLimitExceeded
        default:
            self = .requestFailed
        }
    }

    /// A textual representation of the error.
    public var description: String {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .invalidResponse:
            return "The response from the server was invalid."
        case .requestFailed:
            return "The request to the server failed."
        case .invalidData:
            return "The data received from the server was invalid."
        case .rateLimitExceeded:
            return "The rate limit for the API has been exceeded."
        case .unauthorized:
            return "The request is unauthorized."
        case .forbidden:
            return "The request is forbidden."
        case .notFound:
            return "The requested resource was not found."
        case .badRequest:
            return "The request was malformed."
        }
    }
}
