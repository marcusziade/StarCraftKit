import Foundation

extension DateFormatter {
    /// ISO8601 formatter for full date-time strings
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    /// Simple date formatter for YYYY-MM-DD format
    static let yearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    /// Custom date decoding that handles both ISO8601 and simple date formats
    static let pandaScore = custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        // Try ISO8601 format first (for timestamps)
        if let date = DateFormatter.iso8601Full.date(from: dateString) {
            return date
        }
        
        // Try simple date format (for birthdays)
        if let date = DateFormatter.yearMonthDay.date(from: dateString) {
            return date
        }
        
        // Try the built-in ISO8601 decoder as fallback
        if let date = ISO8601DateFormatter().date(from: dateString) {
            return date
        }
        
        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Expected date string to be ISO8601-formatted or YYYY-MM-DD."
        )
    }
}