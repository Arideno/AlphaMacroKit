//
//  AlphaMacroKitPlugin.swift
//
//
//  Created by Andrii Moisol on 12.10.2023.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AlphaMacroKitPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumCaseCheckerMacro.self,
        AutoNewMacro.self
    ]
}
