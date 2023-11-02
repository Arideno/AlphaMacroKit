//
//  AutoNewMacro.swift
//
//
//  Created by Andrii Moisol on 31.10.2023.
//

import SwiftSyntax
import SwiftSyntaxMacros
import MacroToolkit

public struct AutoNewMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        if let struct_ = Struct(declaration) {
            let members = struct_.members
            let storedPropertiesDecls = members
                .compactMap { $0.asVariable }
                .filter { $0.isStoredProperty }

            let storedProperties = storedPropertiesDecls
                .map { $0.bindings }
                .flatMap {
                    let identifiers = $0.compactMap(\.identifier)
                    let types = $0.compactMap(\.type)
                    return Array(zip(identifiers, types))
                }

            return [
                DeclSyntax(
                    try FunctionDeclSyntax("static func new(\(raw: storedProperties.map({ "\($0.0): \($0.1.description) = .new()" }).joined(separator: ", "))) -> Self") {
                        ".init(\(raw: storedProperties.map({ "\($0.0): \($0.0)" }).joined(separator: ", ")))"
                    }
                ),
                DeclSyntax(
                    try FunctionDeclSyntax("static func new() -> Self") {
                        ".new(\(raw: storedProperties.map({ "\($0.0): .new()" }).joined(separator: ", ")))"
                    }
                )
            ]
        } else if let enum_ = Enum(declaration) {
            let firstCase = enum_.cases.first!

            return [
                DeclSyntax(
                    try FunctionDeclSyntax("static func new() -> Self") {
                        if let parameters = firstCase._syntax.parameterClause?.parameters, !parameters.isEmpty {
                            ".\(raw: firstCase.identifier)(\(raw: parameters.map({ $0.firstName != nil ? "\($0.firstName!.text.replacingOccurrences(of: "`", with: "")): .new()" : ".new()" }).joined(separator: ", ")))"
                        } else {
                            ".\(raw: firstCase.identifier)"
                        }
                    }
                )
            ]
        }

        context.diagnose(AutoNewMacroDiagnostic.requiresStructOrEnum.diagnose(at: declaration))
        return []
    }

    private static func getType(for type: TypeSyntax) -> TokenSyntax? {
        if let identifierSyntax = type.as(IdentifierTypeSyntax.self) {
            if let genericArgumentClause = identifierSyntax.genericArgumentClause {
                return TokenSyntax(stringLiteral: "\(identifierSyntax.name)<\(genericArgumentClause.arguments.map({ "\($0.argument)" }).joined(separator: ","))>")
            }

            return identifierSyntax.name
        }

        if let optionalSyntax = type.as(OptionalTypeSyntax.self) {
            return TokenSyntax(stringLiteral: "\(getType(for: optionalSyntax.wrappedType)!)?")
        }

        if let arraySyntax = type.as(ArrayTypeSyntax.self) {
            return TokenSyntax(stringLiteral: "[\(getType(for: arraySyntax.element)!)]")
        }

        return nil
    }
}
