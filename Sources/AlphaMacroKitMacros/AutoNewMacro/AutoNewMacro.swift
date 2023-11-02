//
//  AutoNewMacro.swift
//
//
//  Created by Andrii Moisol on 31.10.2023.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AutoNewMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        if let structDeclaration = declaration.as(StructDeclSyntax.self) {
            let members = structDeclaration.memberBlock.members
            let storedPropertiesDecls = members
                .compactMap { $0.decl.as(VariableDeclSyntax.self) }
                .filter { !$0.bindings.contains(where: { $0.accessorBlock != nil }) }
            let storedPropertiesTypes = storedPropertiesDecls
                    .flatMap(\.bindings)
                    .map {
                        return ($0.pattern.cast(IdentifierPatternSyntax.self).identifier.text.replacingOccurrences(of: "`", with: ""), getType(for: $0.typeAnnotation!.type)!.text)
                    }

            let decls = [
                DeclSyntax(
                    try FunctionDeclSyntax("static func new(\(raw: storedPropertiesTypes.map({ "\($0.0): \($0.1) = .new()" }).joined(separator: ", "))) -> \(structDeclaration.name)") {
                        ".init(\(raw: storedPropertiesTypes.map({ "\($0.0): \($0.0)" }).joined(separator: ", ")))"
                    }
                ),
                DeclSyntax(
                    try FunctionDeclSyntax("static func new() -> \(structDeclaration.name)") {
                        ".new(\(raw: storedPropertiesTypes.map({ "\($0.0): .new()" }).joined(separator: ", ")))"
                    }
                )
            ]

            return decls
        } else if let enumDeclaration = declaration.as(EnumDeclSyntax.self) {
            let members = enumDeclaration.memberBlock.members
            let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            let firstElement = caseDecls.flatMap(\.elements).first!

            let decl = try FunctionDeclSyntax("static func new() -> \(enumDeclaration.name)") {
                if let parameters = firstElement.parameterClause?.parameters, !parameters.isEmpty {
                    ".\(firstElement.name)(\(raw: parameters.map({ $0.firstName != nil ? "\($0.firstName!.text.replacingOccurrences(of: "`", with: "")): .new()" : ".new()" }).joined(separator: ", ")))"
                } else {
                    ".\(firstElement.name)"
                }
            }

            return [DeclSyntax(decl)]
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
