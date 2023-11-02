//
//  AutoNewTests.swift
//
//
//  Created by Andrii Moisol on 31.10.2023.
//

import SwiftSyntaxMacros
import XCTest
import AlphaMacroKitMacros
import MacroTesting

final class AutoNewTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "AutoNew": AutoNewMacro.self,
    ]

    func testMacro() throws {
        assertMacro(testMacros) {
            #"""
            @AutoNew
            struct User {
                let id: UUID
                let firstName: String
                let lastName: String
                let birthDate: Date?

                var fullName: String {
                    "\(firstName) \(lastName)"
                }
            }
            """#
        } expansion: {
            #"""
            struct User {
                let id: UUID
                let firstName: String
                let lastName: String
                let birthDate: Date?

                var fullName: String {
                    "\(firstName) \(lastName)"
                }

                static func new(id: UUID = .new(), firstName: String = .new(), lastName: String = .new(), birthDate: Date? = .new()) -> Self {
                    .init(id: id, firstName: firstName, lastName: lastName, birthDate: birthDate)
                }
            }
            """#
        }
    }
}

