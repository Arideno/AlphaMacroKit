import AlphaMacroKitMacros
import MacroTesting
import SwiftSyntaxMacros
import XCTest

final class EnumCaseCheckerTests: XCTestCase {
    override func invokeTest() {
        withMacroTesting(macros: [EnumCaseCheckerMacro.self]) {
            super.invokeTest()
        }
    }

    func testMacro() throws {
        assertMacro {
            """
            @EnumCaseChecker
            enum State {
                case error(Int)
                case data
                case loading
            }
            """
        } expansion: {
            """
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
            """
        }
    }

    func testMacroCamelCaseNames() throws {
        assertMacro {
            """
            @EnumCaseChecker
            enum State {
                case error(Int)
                case data
                case loadingScreen
            }
            """
        } expansion: {
            """
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
            """
        }
    }

    func testMacroNotOnEnum() throws {
        assertMacro {
            """
            @EnumCaseChecker
            class State {}
            """
        } diagnostics: {
            """
            @EnumCaseChecker
            ╰─ 🛑 'EnumCaseChecker' macro can only be applied to an enum
            class State {}
            """
        }
    }

    func testReservedKeyword() throws {
        assertMacro {
            """
            @EnumCaseChecker
            enum State {
                case `continue`
            }
            """
        } expansion: {
            """
            enum State {
                case `continue`

                var isContinue: Bool {
                    guard case .continue = self else {
                        return false
                    }
                    return true
                }
            }
            """
        }
    }
}
