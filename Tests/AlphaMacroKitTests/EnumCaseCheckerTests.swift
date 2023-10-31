import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import AlphaMacroKitMacros

final class EnumCaseCheckerTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "EnumCaseChecker": EnumCaseCheckerMacro.self,
    ]

    func testMacro() throws {
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
    }

    func testMacroCamelCaseNames() throws {
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
    }

    func testMacroNotOnEnum() throws {
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
    }

    func testReservedKeyword() throws {
        assertMacroExpansion(
            """
            @EnumCaseChecker
            enum State {
                case `continue`
            }
            """,
            expandedSource: """
            enum State {
                case `continue`

                var isContinue: Bool {
                    guard case .continue = self else {
                        return false
                    }
                    return true
                }
            }
            """,
            macros: testMacros
        )
    }
}
