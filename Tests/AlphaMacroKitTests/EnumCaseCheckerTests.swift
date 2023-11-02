//
//  EnumCaseCheckerTests.swift
//
//
//  Created by Andrii Moisol on 31.10.2023.
//

import SwiftSyntaxMacros
import XCTest
import AlphaMacroKitMacros
import MacroTesting

final class EnumCaseCheckerTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "EnumCaseChecker": EnumCaseCheckerMacro.self,
    ]

    func testMacro() throws {
        assertMacro(testMacros) {
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
        assertMacro(testMacros) {
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
        assertMacro(testMacros) {
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
        assertMacro(testMacros) {
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
