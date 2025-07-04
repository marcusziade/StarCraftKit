import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Logging

/// Configuration for retry behavior
public struct RetryConfiguration: Sendable {
    /// Maximum number of retry attempts
    public let maxAttempts: Int
    
    /// Initial delay before first retry (in seconds)
    public let initialDelay: TimeInterval
    
    /// Maximum delay between retries (in seconds)
    public let maxDelay: TimeInterval
    
    /// Multiplier for exponential backoff
    public let backoffMultiplier: Double
    
    /// Add jitter to prevent thundering herd
    public let jitterRange: ClosedRange<Double>
    
    public init(
        maxAttempts: Int = 3,
        initialDelay: TimeInterval = 1.0,
        maxDelay: TimeInterval = 60.0,
        backoffMultiplier: Double = 2.0,
        jitterRange: ClosedRange<Double> = 0.8...1.2
    ) {
        self.maxAttempts = maxAttempts
        self.initialDelay = initialDelay
        self.maxDelay = maxDelay
        self.backoffMultiplier = backoffMultiplier
        self.jitterRange = jitterRange
    }
    
    /// Default configuration for API requests
    public static let `default` = RetryConfiguration()
    
    /// Aggressive retry for critical operations
    public static let aggressive = RetryConfiguration(
        maxAttempts: 5,
        initialDelay: 0.5,
        maxDelay: 30.0,
        backoffMultiplier: 1.5
    )
    
    /// Conservative retry for non-critical operations
    public static let conservative = RetryConfiguration(
        maxAttempts: 2,
        initialDelay: 2.0,
        maxDelay: 10.0,
        backoffMultiplier: 2.0
    )
}

/// Handles retry logic with exponential backoff
public struct RetryHandler {
    private let configuration: RetryConfiguration
    private let logger: Logger
    
    public init(
        configuration: RetryConfiguration = .default,
        logger: Logger = Logger(label: "StarCraftKit.RetryHandler")
    ) {
        self.configuration = configuration
        self.logger = logger
    }
    
    /// Execute an operation with retry logic
    public func execute<T>(
        operation: @escaping () async throws -> T,
        shouldRetry: @escaping (Error) -> Bool = { ($0 as? APIError)?.isRetryable ?? false }
    ) async throws -> T {
        var lastError: Error?
        
        for attempt in 0..<configuration.maxAttempts {
            do {
                let result = try await operation()
                if attempt > 0 {
                    logger.info("Operation succeeded after \(attempt) retries")
                }
                return result
            } catch {
                lastError = error
                
                if !shouldRetry(error) {
                    logger.debug("Error is not retryable: \(error)")
                    throw error
                }
                
                if attempt == configuration.maxAttempts - 1 {
                    logger.error("Max retry attempts (\(configuration.maxAttempts)) reached")
                    throw error
                }
                
                let delay = calculateDelay(for: attempt, error: error)
                logger.warning("Attempt \(attempt + 1) failed: \(error). Retrying in \(String(format: "%.2f", delay))s")
                
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        
        throw lastError ?? APIError.networkError(underlying: URLError(.unknown))
    }
    
    private func calculateDelay(for attempt: Int, error: Error) -> TimeInterval {
        var delay: TimeInterval
        
        if let apiError = error as? APIError,
           let suggestedDelay = apiError.suggestedRetryDelay {
            delay = suggestedDelay
        } else {
            delay = configuration.initialDelay * pow(configuration.backoffMultiplier, Double(attempt))
        }
        
        delay = min(delay, configuration.maxDelay)
        
        let jitter = Double.random(in: configuration.jitterRange)
        delay *= jitter
        
        return delay
    }
}

/// Extension to make retry handler work with APIRequest
public extension RetryHandler {
    func executeRequest<T: Decodable>(
        client: NetworkingClient,
        request: URLRequest,
        responseType: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> (data: T, headers: [String: String]) {
        try await execute {
            try await client.execute(request, responseType: responseType, decoder: decoder)
        }
    }
}