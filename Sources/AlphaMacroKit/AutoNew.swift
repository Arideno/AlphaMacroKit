//
//  AutoNew.swift
//  
//
//  Created by Andrii Moisol on 31.10.2023.
//

import Foundation
import CoreGraphics

@attached(extension, conformances: AutoNew, names: named(new))
public macro AutoNew() = #externalMacro(module: "AlphaMacroKitMacros", type: "AutoNewMacro")

public protocol AutoNew {
    static func new() -> Self
}

extension Int: AutoNew { 
    static public func new() -> Int { .init() }
}
extension String: AutoNew {
    static public func new() -> String { .init() }
}
extension Date: AutoNew {
    static public func new() -> Date { .init() }
}
extension UUID: AutoNew {
    static public func new() -> UUID { .init() }
}
extension Data: AutoNew {
    static public func new() -> Data { .init() }
}
extension CGPoint: AutoNew {
    static public func new() -> CGPoint { .init() }
}
extension CGRect: AutoNew {
    static public func new() -> CGRect { .init() }
}
extension Double: AutoNew {
    static public func new() -> Double { .init() }
}
extension Float: AutoNew {
    static public func new() -> Float { .init() }
}
extension Optional where Wrapped: AutoNew {
    static func new() -> Wrapped? { Wrapped.new() }
}

