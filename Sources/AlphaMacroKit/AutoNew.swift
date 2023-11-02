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
