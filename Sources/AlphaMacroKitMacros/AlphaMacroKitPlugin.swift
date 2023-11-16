import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AlphaMacroKitPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumCaseCheckerMacro.self,
        AutoNewMacro.self,
    ]
}
