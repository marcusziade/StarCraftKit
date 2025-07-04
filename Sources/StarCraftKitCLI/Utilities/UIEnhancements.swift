import Foundation
import StarCraftKit

// MARK: - Country Flags
public enum CountryFlag {
    private static let countryToEmoji: [String: String] = [
        // Common StarCraft 2 countries
        "Korea": "🇰🇷", "South Korea": "🇰🇷", "KR": "🇰🇷",
        "United States": "🇺🇸", "USA": "🇺🇸", "US": "🇺🇸",
        "Germany": "🇩🇪", "DE": "🇩🇪",
        "France": "🇫🇷", "FR": "🇫🇷",
        "Canada": "🇨🇦", "CA": "🇨🇦",
        "Poland": "🇵🇱", "PL": "🇵🇱",
        "Finland": "🇫🇮", "FI": "🇫🇮",
        "Sweden": "🇸🇪", "SE": "🇸🇪",
        "Norway": "🇳🇴", "NO": "🇳🇴",
        "Denmark": "🇩🇰", "DK": "🇩🇰",
        "Netherlands": "🇳🇱", "NL": "🇳🇱",
        "United Kingdom": "🇬🇧", "UK": "🇬🇧", "GB": "🇬🇧",
        "Italy": "🇮🇹", "IT": "🇮🇹",
        "Spain": "🇪🇸", "ES": "🇪🇸",
        "Mexico": "🇲🇽", "MX": "🇲🇽",
        "Brazil": "🇧🇷", "BR": "🇧🇷",
        "Australia": "🇦🇺", "AU": "🇦🇺",
        "China": "🇨🇳", "CN": "🇨🇳",
        "Taiwan": "🇹🇼", "TW": "🇹🇼",
        "Japan": "🇯🇵", "JP": "🇯🇵",
        "Russia": "🇷🇺", "RU": "🇷🇺",
        "Ukraine": "🇺🇦", "UA": "🇺🇦",
        "Austria": "🇦🇹", "AT": "🇦🇹",
        "Switzerland": "🇨🇭", "CH": "🇨🇭",
        "Belgium": "🇧🇪", "BE": "🇧🇪",
        "Czech Republic": "🇨🇿", "CZ": "🇨🇿",
        "Romania": "🇷🇴", "RO": "🇷🇴",
        "Hungary": "🇭🇺", "HU": "🇭🇺",
        "Israel": "🇮🇱", "IL": "🇮🇱",
        "Singapore": "🇸🇬", "SG": "🇸🇬",
        "India": "🇮🇳", "IN": "🇮🇳",
        "Argentina": "🇦🇷", "AR": "🇦🇷",
        "Chile": "🇨🇱", "CL": "🇨🇱",
        "Peru": "🇵🇪", "PE": "🇵🇪",
        "Portugal": "🇵🇹", "PT": "🇵🇹",
        "Turkey": "🇹🇷", "TR": "🇹🇷",
        "Greece": "🇬🇷", "GR": "🇬🇷",
        "New Zealand": "🇳🇿", "NZ": "🇳🇿",
        "Philippines": "🇵🇭", "PH": "🇵🇭",
        "Vietnam": "🇻🇳", "VN": "🇻🇳",
        "Thailand": "🇹🇭", "TH": "🇹🇭",
        "Indonesia": "🇮🇩", "ID": "🇮🇩",
        "Malaysia": "🇲🇾", "MY": "🇲🇾"
    ]
    
    public static func flag(for country: String?) -> String {
        guard let country = country else { return "🌍" }
        return countryToEmoji[country] ?? "🌍"
    }
}

// MARK: - Colors
public enum ANSIColor: String {
    case reset = "\u{001B}[0m"
    case black = "\u{001B}[30m"
    case red = "\u{001B}[31m"
    case green = "\u{001B}[32m"
    case yellow = "\u{001B}[33m"
    case blue = "\u{001B}[34m"
    case magenta = "\u{001B}[35m"
    case cyan = "\u{001B}[36m"
    case white = "\u{001B}[37m"
    case gray = "\u{001B}[90m"
    case brightRed = "\u{001B}[91m"
    case brightGreen = "\u{001B}[92m"
    case brightYellow = "\u{001B}[93m"
    case brightBlue = "\u{001B}[94m"
    case brightMagenta = "\u{001B}[95m"
    case brightCyan = "\u{001B}[96m"
    case brightWhite = "\u{001B}[97m"
    
    // Background colors
    case bgRed = "\u{001B}[41m"
    case bgGreen = "\u{001B}[42m"
    case bgYellow = "\u{001B}[43m"
    case bgBlue = "\u{001B}[44m"
    
    // Styles
    case bold = "\u{001B}[1m"
    case dim = "\u{001B}[2m"
    case italic = "\u{001B}[3m"
    case underline = "\u{001B}[4m"
}

public extension String {
    func colored(_ color: ANSIColor) -> String {
        return "\(color.rawValue)\(self)\(ANSIColor.reset.rawValue)"
    }
    
    func bold() -> String {
        return "\(ANSIColor.bold.rawValue)\(self)\(ANSIColor.reset.rawValue)"
    }
    
    var red: String { colored(.red) }
    var green: String { colored(.green) }
    var yellow: String { colored(.yellow) }
    var blue: String { colored(.blue) }
    var cyan: String { colored(.cyan) }
    var gray: String { colored(.gray) }
    var brightGreen: String { colored(.brightGreen) }
    var brightYellow: String { colored(.brightYellow) }
    var brightRed: String { colored(.brightRed) }
    var brightMagenta: String { colored(.brightMagenta) }
    var brightBlue: String { colored(.brightBlue) }
}

// MARK: - Time Formatting
public extension Date {
    var relativeTime: String {
        let now = Date()
        let interval = self.timeIntervalSince(now)
        
        if interval > 0 {
            // Future
            if interval < 60 { return "in \(Int(interval))s" }
            if interval < 3600 { return "in \(Int(interval / 60))m" }
            if interval < 86400 { return "in \(Int(interval / 3600))h" }
            if interval < 604800 { return "in \(Int(interval / 86400))d" }
            return self.formattedString
        } else {
            // Past
            let absInterval = abs(interval)
            if absInterval < 60 { return "\(Int(absInterval))s ago" }
            if absInterval < 3600 { return "\(Int(absInterval / 60))m ago" }
            if absInterval < 86400 { return "\(Int(absInterval / 3600))h ago" }
            if absInterval < 604800 { return "\(Int(absInterval / 86400))d ago" }
            return self.formattedString
        }
    }
    
    var timeOnly: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    var dateOnly: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: self)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
}

// MARK: - Match Status Formatting
public extension String {
    static func matchStatus(_ status: String) -> String {
        switch status.lowercased() {
        case "running":
            return "● LIVE".brightGreen
        case "not_started":
            return "◯ Upcoming".yellow
        case "finished":
            return "✓ Finished".gray
        default:
            return status
        }
    }
}

// MARK: - Table Formatting
public struct TableFormatter {
    public static func divider(_ width: Int = 80) -> String {
        String(repeating: "─", count: width)
    }
    
    public static func header(_ text: String, width: Int = 80) -> String {
        let padding = max(0, width - text.count - 4) / 2
        let leftPad = String(repeating: "─", count: padding)
        let rightPad = String(repeating: "─", count: width - text.count - 4 - padding)
        return "┌\(leftPad) \(text.bold()) \(rightPad)┐"
    }
    
    public static func footer(width: Int = 80) -> String {
        "└" + String(repeating: "─", count: width - 2) + "┘"
    }
    
    public static func truncate(_ text: String, to length: Int) -> String {
        if text.count <= length {
            // Use a simple padding approach that preserves Unicode
            let paddingNeeded = length - text.count
            return text + String(repeating: " ", count: paddingNeeded)
        }
        return String(text.prefix(length - 3)) + "..."
    }
}

// MARK: - Progress Bar
public struct ProgressBar {
    public static func create(current: Int, total: Int, width: Int = 20) -> String {
        guard total > 0 else { return "" }
        let progress = Double(current) / Double(total)
        let filled = Int(progress * Double(width))
        let empty = width - filled
        
        let bar = String(repeating: "█", count: filled) + String(repeating: "░", count: empty)
        let percentage = Int(progress * 100)
        
        return "[\(bar)] \(percentage)%"
    }
}

// MARK: - Race Icons
public enum RaceIcon {
    public static func icon(for race: String?) -> String {
        switch race?.lowercased() {
        case "terran": return "T"
        case "protoss": return "P"
        case "zerg": return "Z"
        case "random": return "R"
        default: return "?"
        }
    }
}

// MARK: - Prize Pool Formatting
public extension Int {
    var formattedPrize: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "$\(self)"
    }
}

// MARK: - Stream Links
public struct StreamFormatter {
    public static func formatStreamLink(_ url: String?) -> String {
        guard let url = url else { return "No stream" }
        if url.contains("twitch.tv") {
            return "📺 Twitch".brightMagenta
        } else if url.contains("youtube.com") || url.contains("youtu.be") {
            return "📺 YouTube".brightRed
        } else {
            return "📺 Stream".brightBlue
        }
    }
}

// MARK: - Date Formatting
public extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}

// MARK: - Time Duration Formatting
public extension TimeInterval {
    var formattedDuration: String {
        let hours = Int(self) / 3600
        let minutes = Int(self) % 3600 / 60
        let seconds = Int(self) % 60
        
        if hours > 0 {
            return "\(hours)h \(String(minutes).padding(toLength: 2, withPad: "0", startingAt: 0))m"
        } else if minutes > 0 {
            return "\(minutes)m \(String(seconds).padding(toLength: 2, withPad: "0", startingAt: 0))s"
        } else {
            return "\(seconds)s"
        }
    }
}

// MARK: - Int Duration Extension
public extension Int {
    var formattedDuration: String {
        TimeInterval(self).formattedDuration
    }
}

// Match and OpponentDetails extensions already exist in StarCraftCLI.swift and OpponentExtensions.swift

// MARK: - Tournament Extensions
public extension Tournament {
    var isRunning: Bool {
        let now = Date()
        if let beginAt = beginAt, let endAt = endAt {
            return now >= beginAt && now <= endAt
        }
        return false
    }
    
    var isPending: Bool {
        guard let beginAt = beginAt else { return false }
        return Date() < beginAt
    }
    
    var hasEnded: Bool {
        guard let endAt = endAt else { return false }
        return Date() > endAt
    }
}

// MARK: - Series Extensions
public extension Series {
    var isRunning: Bool {
        let now = Date()
        if let beginAt = beginAt, let endAt = endAt {
            return now >= beginAt && now <= endAt
        }
        return false
    }
    
    var isPending: Bool {
        guard let beginAt = beginAt else { return false }
        return Date() < beginAt
    }
    
    var hasEnded: Bool {
        guard let endAt = endAt else { return false }
        return Date() > endAt
    }
}

// MARK: - Double Extensions
public extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}