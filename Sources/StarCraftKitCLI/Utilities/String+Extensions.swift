import Foundation

// Helper extension for string repetition
extension String {
    static func * (left: String, right: Int) -> String {
        String(repeating: left, count: right)
    }
}