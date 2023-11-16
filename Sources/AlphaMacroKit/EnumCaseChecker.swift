@attached(member, names: arbitrary)
public macro EnumCaseChecker() =
    #externalMacro(module: "AlphaMacroKitMacros", type: "EnumCaseCheckerMacro")
