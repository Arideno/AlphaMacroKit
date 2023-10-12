import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct EnumCaseCheckerMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard declaration.is(EnumDeclSyntax.self) else {
            context.diagnose(EnumCaseCheckerMacroDiagnostic.requiresEnum.diagnose(at: declaration))
            return []
        }

        let members = declaration.memberBlock.members
        let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let elements = caseDecls.flatMap(\.elements)

        var computedProperties = [VariableDeclSyntax]()

        for element in elements {
            let computedProperty = try VariableDeclSyntax("var is\(raw: element.name.text.capitalizingFirstLetter()): Bool") {
                try GuardStmtSyntax("guard case .\(element.name) = self else") {
                    "return false"
                }

                "return true"
            }
            computedProperties.append(computedProperty)
        }

        return computedProperties.map { DeclSyntax($0) }
    }
}
