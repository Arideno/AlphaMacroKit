import AlphaMacroKitMacros
import MacroTesting
import SwiftSyntaxMacros
import XCTest

final class AutoNewTests: XCTestCase {
    override func invokeTest() {
        withMacroTesting(macros: [AutoNewMacro.self]) {
            super.invokeTest()
        }
    }

    func testMacro() throws {
        assertMacro {
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
