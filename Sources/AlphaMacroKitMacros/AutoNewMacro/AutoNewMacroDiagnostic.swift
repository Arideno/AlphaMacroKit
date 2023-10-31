//
//  AutoNewMacroDiagnostic.swift
//
//
//  Created by Andrii Moisol on 31.10.2023.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum AutoNewMacroDiagnostic {
    case requiresStructOrEnum
}

extension AutoNewMacroDiagnostic: DiagnosticMessage {
    var message: String {
        switch self {
        case .requiresStructOrEnum:
            return "'AutoNew' macro can only be applied to a struct or enum"
        }
    }

    var diagnosticID: SwiftDiagnostics.MessageID {
        MessageID(domain: "Swift", id: "AutoNew.\(self)")
    }

    var severity: SwiftDiagnostics.DiagnosticSeverity { .error }

    func diagnose(at node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: Syntax(node), message: self)
    }
}
