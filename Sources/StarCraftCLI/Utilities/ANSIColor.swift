enum ANSIColor {
    static let reset = "\u{001B}[0m"
    static let bold = "\u{001B}[1m"
    
    // Race Colors
    static let protoss = "\u{001B}[38;2;255;223;0m"    // Golden yellow
    static let terran = "\u{001B}[38;2;0;156;255m"     // Bright blue
    static let zerg = "\u{001B}[38;2;163;53;238m"      // Purple
    
    // Accent Colors
    static let neon = "\u{001B}[38;2;0;255;255m"       // Cyan
    static let warning = "\u{001B}[38;2;255;69;0m"     // Red-Orange
    static let success = "\u{001B}[38;2;50;205;50m"    // Lime Green
}
