//
//  AutoNew.swift
//  
//
//  Created by Andrii Moisol on 31.10.2023.
//

import Foundation
import CoreGraphics

@attached(member, names: named(new))
public macro AutoNew() = #externalMacro(module: "AlphaMacroKitMacros", type: "AutoNewMacro")

public protocol AutoNew {
    static func new() -> Self
}

extension Int: AutoNew { 
    public static func new() -> Int { .init() }
}
extension String: AutoNew {
    public static func new() -> String { .init() }
}
extension Date: AutoNew {
    public static func new() -> Date { .init() }
}
extension UUID: AutoNew {
    public static func new() -> UUID { .init() }
}
extension Data: AutoNew {
    public static func new() -> Data { .init() }
}
extension Bool: AutoNew {
    public static func new() -> Bool { false }
}
extension CGPoint: AutoNew {
    public static func new() -> CGPoint { .init() }
}
extension CGRect: AutoNew {
    public static func new() -> CGRect { .init() }
}
extension Double: AutoNew {
    public static func new() -> Double { .init() }
}
extension Float: AutoNew {
    public static func new() -> Float { .init() }
}
extension Optional where Wrapped: AutoNew {
    public static func new() -> Wrapped? { nil }
}
extension Array: AutoNew {
    public static func new() -> [Element] { [] }
}
extension URL: AutoNew {
    public static func new() -> URL { URL(string: "https://google.com")! }
}
extension Set: AutoNew {
    public static func new() -> Set<Element> { .init() }
}
extension Dictionary: AutoNew {
    public static func new() -> Dictionary { [:] }
}
extension NSAttributedString {
    public static func new() -> NSAttributedString { .init() }
}
extension Int64: AutoNew {
    public static func new() -> Int64 { .init() }
}
extension UInt: AutoNew {
    public static func new() -> UInt { .init() }
}
