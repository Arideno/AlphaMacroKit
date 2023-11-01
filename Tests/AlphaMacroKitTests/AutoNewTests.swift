//
//  AutoNewTests.swift
//
//
//  Created by Andrii Moisol on 31.10.2023.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import AlphaMacroKitMacros

final class AutoNewTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "AutoNew": AutoNewMacro.self,
    ]

    func testMacro() throws {
        assertMacroExpansion(
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
            """#,
            expandedSource: #"""
            struct User {
                let id: UUID
                let firstName: String
                let lastName: String
                let birthDate: Date?

                var fullName: String {
                    "\(firstName) \(lastName)"
                }

                static func new(id: UUID = .new(), firstName: String = .new(), lastName: String = .new(), birthDate: Date? = .new()) -> User  {
                    .init(id: id, firstName: firstName, lastName: lastName, birthDate: birthDate)
                }

                static func new() -> User  {
                    .new(id: .new(), firstName: .new(), lastName: .new(), birthDate: .new())
                }
            }
            """#,
            macros: testMacros
        )
    }
}

