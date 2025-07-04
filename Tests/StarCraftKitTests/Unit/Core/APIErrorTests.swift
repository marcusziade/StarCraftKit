import XCTest
@testable import StarCraftKit

final class APIErrorTests: XCTestCase {
    func testErrorDescriptions() {
        let networkError = APIError.networkError(underlying: URLError(.notConnectedToInternet))
        XCTAssertTrue(networkError.errorDescription?.contains("Network error") ?? false)
        
        let httpError = APIError.httpError(statusCode: 400, response: ErrorResponse(error: "bad_request", message: "Invalid parameters"))
        XCTAssertEqual(httpError.errorDescription, "HTTP 400: Invalid parameters")
        
        let unauthorized = APIError.unauthorized(message: "Invalid token")
        XCTAssertEqual(unauthorized.errorDescription, "Unauthorized: Invalid token")
        
        let rateLimitError = APIError.rateLimitExceeded(retryAfter: 60, remaining: 0)
        XCTAssertTrue(rateLimitError.errorDescription?.contains("60s") ?? false)
        XCTAssertTrue(rateLimitError.errorDescription?.contains("remaining: 0") ?? false)
    }
    
    func testRetryableErrors() {
        XCTAssertTrue(APIError.networkError(underlying: URLError(.timedOut)).isRetryable)
        XCTAssertTrue(APIError.timeout.isRetryable)
        XCTAssertTrue(APIError.serverError(statusCode: 500, message: nil).isRetryable)
        XCTAssertTrue(APIError.rateLimitExceeded(retryAfter: nil, remaining: nil).isRetryable)
        
        XCTAssertFalse(APIError.unauthorized(message: "").isRetryable)
        XCTAssertFalse(APIError.forbidden(message: "").isRetryable)
        XCTAssertFalse(APIError.notFound(resource: "").isRetryable)
        XCTAssertFalse(APIError.invalidRequest(reason: "").isRetryable)
    }
    
    func testSuggestedRetryDelay() {
        let rateLimitError = APIError.rateLimitExceeded(retryAfter: 30, remaining: 0)
        XCTAssertEqual(rateLimitError.suggestedRetryDelay, 30)
        
        let serverError = APIError.serverError(statusCode: 503, message: nil)
        XCTAssertEqual(serverError.suggestedRetryDelay, 5.0)
        
        let networkError = APIError.networkError(underlying: URLError(.notConnectedToInternet))
        XCTAssertEqual(networkError.suggestedRetryDelay, 2.0)
        
        let timeout = APIError.timeout
        XCTAssertEqual(timeout.suggestedRetryDelay, 2.0)
        
        let nonRetryable = APIError.forbidden(message: "")
        XCTAssertNil(nonRetryable.suggestedRetryDelay)
    }
    
    func testErrorResponseCoding() throws {
        let errorResponse = ErrorResponse(error: "rate_limit_exceeded", message: "Too many requests")
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(errorResponse)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(ErrorResponse.self, from: data)
        
        XCTAssertEqual(decoded.error, errorResponse.error)
        XCTAssertEqual(decoded.message, errorResponse.message)
    }
}