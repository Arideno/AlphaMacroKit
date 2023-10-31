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

public struct AutoNewMacro: ExtensionMacro {
    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        if let structDeclaration = declaration.as(StructDeclSyntax.self) {
            let members = structDeclaration.memberBlock.members
            let storedPropertiesDecls = members
                .compactMap { $0.decl.as(VariableDeclSyntax.self) }
                .filter { !$0.bindings.contains(where: { $0.accessorBlock != nil }) }
            let storedPropertiesTypes = storedPropertiesDecls
                    .flatMap(\.bindings)
                    .map {
                        var identifierTypeString: String
                        if let optionalSyntax = $0.typeAnnotation!.type.as(OptionalTypeSyntax.self) {
                            identifierTypeString = optionalSyntax.wrappedType.cast(IdentifierTypeSyntax.self).name.text + "?"
                        } else {
                            identifierTypeString = $0.typeAnnotation!.type.cast(IdentifierTypeSyntax.self).name.text
                        }
                        return ($0.pattern.cast(IdentifierPatternSyntax.self).identifier.text.replacingOccurrences(of: "`", with: ""), identifierTypeString)
                    }

            let decl = try ExtensionDeclSyntax("extension \(structDeclaration.name): AutoNew") {
                try FunctionDeclSyntax("static func new(\(raw: storedPropertiesTypes.map({ "\($0.0): \($0.1) = .new()" }).joined(separator: ", "))) -> \(structDeclaration.name)") {
                    ".init(\(raw: storedPropertiesTypes.map({ "\($0.0): \($0.0)" }).joined(separator: ", ")))"
                }

                try FunctionDeclSyntax("static func new() -> \(structDeclaration.name)") {
                    ".new(\(raw: storedPropertiesTypes.map({ "\($0.0): .new()" }).joined(separator: ", ")))"
                }
            }

            return [decl]
        } else if let enumDeclaration = declaration.as(EnumDeclSyntax.self) {
            let members = enumDeclaration.memberBlock.members
            let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            let firstElement = caseDecls.flatMap(\.elements).first!

            let decl = try ExtensionDeclSyntax("extension \(enumDeclaration.name): AutoNew") {
                try FunctionDeclSyntax("static func new() -> \(enumDeclaration.name)") {
                    if let parameters = firstElement.parameterClause?.parameters, !parameters.isEmpty {
                        ".\(firstElement.name)(\(raw: parameters.map({ $0.firstName != nil ? "\($0.firstName!.text.replacingOccurrences(of: "`", with: "")): .new()" : ".new()" }).joined(separator: ", ")))"
                    } else {
                        ".\(firstElement.name)"
                    }
                }
            }

            return [decl]
        }

        context.diagnose(AutoNewMacroDiagnostic.requiresStructOrEnum.diagnose(at: declaration))
        return []
    }
}
