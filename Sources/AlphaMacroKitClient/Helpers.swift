import Foundation

extension Int {
    static func new() -> Int { .init() }
}
extension String {
    static func new() -> String { .init() }
}
extension Date {
    static func new() -> Date { .init() }
}
extension UUID {
    static func new() -> UUID { .init() }
}
extension Data {
    static func new() -> Data { .init() }
}
extension Bool {
    static func new() -> Bool { false }
}
extension CGPoint {
    static func new() -> CGPoint { .init() }
}
extension CGRect {
    static func new() -> CGRect { .init() }
}
extension Double {
    static func new() -> Double { .init() }
}
extension Float {
    static func new() -> Float { .init() }
}
extension Optional {
    static func new() -> Wrapped? { nil }
}
extension Array {
    static func new() -> [Element] { [] }
}
extension URL {
    static func new() -> URL { URL(string: "https://google.com")! }
}
extension Set {
    static func new() -> Set<Element> { .init() }
}
extension Dictionary {
    static func new() -> Dictionary { [:] }
}
extension Int64 {
    static func new() -> Int64 { .init() }
}
extension UInt {
    static func new() -> UInt { .init() }
}
