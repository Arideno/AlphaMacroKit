//
//  File.swift
//  
//
//  Created by Andrii Moisol on 12.10.2023.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct EnumCaseCheckerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumCaseCheckerMacro.self,
    ]
}
