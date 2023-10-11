// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: arbitrary)
public macro EnumCaseChecker() = #externalMacro(module: "EnumCaseCheckerMacros", type: "EnumCaseCheckerMacro")
