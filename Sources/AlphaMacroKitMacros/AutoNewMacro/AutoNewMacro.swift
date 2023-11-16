import MacroToolkit
import SwiftSyntax
import SwiftSyntaxMacros

public struct AutoNewMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        if let struct_ = Struct(declaration) {
            let members = struct_.members
            let storedPropertiesDecls =
                members
                .compactMap { $0.asVariable }
                .filter { $0.isStoredProperty }

            let storedProperties =
                storedPropertiesDecls
                .map { $0.bindings }
                .flatMap {
                    let identifiers = $0.compactMap(\.identifier)
                    let types = $0.compactMap(\.type)
                    return Array(zip(identifiers, types))
                }

            return [
                DeclSyntax(
                    try FunctionDeclSyntax(
                        "static func new(\(raw: storedProperties.map({ "\($0.0): \($0.1.description) = .new()" }).joined(separator: ", "))) -> Self"
                    ) {
                        ".init(\(raw: storedProperties.map({ "\($0.0): \($0.0)" }).joined(separator: ", ")))"
                    }
                )
            ]
        }
        else if let enum_ = Enum(declaration) {
            guard let firstCase = enum_.cases.first else {
                context.diagnose(
                    DiagnosticBuilder(for: declaration)
                        .message("Enum should contain at least one case")
                        .messageID(domain: "AutoNewMacro", id: "NoEnumCase")
                        .severity(.error)
                        .build()
                )
                return []
            }

            return [
                DeclSyntax(
                    try FunctionDeclSyntax("static func new() -> Self") {
                        if let parameters = firstCase._syntax.parameterClause?.parameters,
                            !parameters.isEmpty
                        {
                            ".\(raw: firstCase.identifier)(\(raw: parameters.map({ $0.firstName != nil ? "\($0.firstName!.text.replacingOccurrences(of: "`", with: "")): .new()" : ".new()" }).joined(separator: ", ")))"
                        }
                        else {
                            ".\(raw: firstCase.identifier)"
                        }
                    }
                )
            ]
        }

        context.diagnose(
            DiagnosticBuilder(for: declaration)
                .message("'AutoNew' macro can only be applied to a struct or enum")
                .messageID(domain: "AutoNewMacro", id: "WrongUsage")
                .severity(.error)
                .build()
        )
        return []
    }
}
