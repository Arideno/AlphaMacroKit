//
//  Diagnostics.swift
//  
//
//  Created by Andrii Moisol on 11.10.2023.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum EnumCaseCheckerMacroDiagnostic {
    case requiresEnum
}

extension EnumCaseCheckerMacroDiagnostic: DiagnosticMessage {
    var message: String {
        switch self {
        case .requiresEnum:
            return "'EnumCaseChecker' macro can only be applied to an enum"
        }
    }
    
    var diagnosticID: SwiftDiagnostics.MessageID {
        MessageID(domain: "Swift", id: "EnumCaseChecker.\(self)")
    }
    
    var severity: SwiftDiagnostics.DiagnosticSeverity { .error }

    func diagnose(at node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: Syntax(node), message: self)
    }
}
