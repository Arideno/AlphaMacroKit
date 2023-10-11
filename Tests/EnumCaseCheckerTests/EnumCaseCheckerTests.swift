import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(EnumCaseCheckerMacros)
import EnumCaseCheckerMacros

let testMacros: [String: Macro.Type] = [
    "EnumCaseChecker": EnumCaseCheckerMacro.self,
]
#endif

final class EnumCaseCheckerTests: XCTestCase {
    func testMacro() throws {
        #if canImport(EnumCaseCheckerMacros)
        assertMacroExpansion(
            """
            @EnumCaseChecker
            enum State {
                case error(Int)
                case data
                case loading
            }
            """,
            expandedSource: """
            enum State {
                case error(Int)
                case data
                case loading

                var isError: Bool {
                    guard case .error = self else {
                        return false
                    }
                    return true
                }

                var isData: Bool {
                    guard case .data = self else {
                        return false
                    }
                    return true
                }

                var isLoading: Bool {
                    guard case .loading = self else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
