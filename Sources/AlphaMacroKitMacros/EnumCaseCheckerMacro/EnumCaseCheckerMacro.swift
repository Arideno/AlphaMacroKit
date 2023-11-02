//
//  EnumCaseCheckerMacro.swift
//
//
//  Created by Andrii Moisol on 31.10.2023.
//

import SwiftSyntax
import SwiftSyntaxMacros
import MacroToolkit

public struct EnumCaseCheckerMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let enum_ = Enum(declaration) else {
            context.diagnose(
                DiagnosticBuilder(for: declaration)
                    .message("'EnumCaseChecker' macro can only be applied to an enum")
                    .messageID(domain: "EnumCaseChecker", id: "WrongUsage")
                    .severity(.error)
                    .build()
            )
            return []
        }

        let cases = enum_.cases

        var computedProperties = [VariableDeclSyntax]()

        for `case` in cases {
            let caseName = `case`.identifier.replacingOccurrences(of: "`", with: "")
            let computedProperty = try VariableDeclSyntax("var is\(raw: caseName.capitalizingFirstLetter()): Bool") {
                try GuardStmtSyntax("guard case .\(raw: caseName) = self else") {
                    "return false"
                }

                "return true"
            }
            computedProperties.append(computedProperty)
        }

        return computedProperties.map { DeclSyntax($0) }
    }
}
