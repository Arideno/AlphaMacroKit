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

    func testMacroCamelCaseNames() throws {
        #if canImport(EnumCaseCheckerMacros)
        assertMacroExpansion(
            """
            @EnumCaseChecker
            enum State {
                case error(Int)
                case data
                case loadingScreen
            }
            """,
            expandedSource: """
            enum State {
                case error(Int)
                case data
                case loadingScreen

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

                var isLoadingScreen: Bool {
                    guard case .loadingScreen = self else {
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

    func testMacroNotOnEnum() throws {
        #if canImport(EnumCaseCheckerMacros)
        assertMacroExpansion(
            """
            @EnumCaseChecker
            class State {}
            """,
            expandedSource:
            """
            class State {}
            """,
            diagnostics: [.init(message: "'EnumCaseChecker' macro can only be applied to an enum", line: 1, column: 1)],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
