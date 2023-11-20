/// `EnumCaseChecker` is a macro used to automatically generate boolean properties for each case in a Swift enumeration.
/// This macro, when attached to an enum, adds computed properties that check for specific enum cases, improving readability and maintainability.
///
/// ## Overview
/// The `EnumCaseChecker` macro simplifies the process of checking enum cases by generating boolean computed properties for each case.
/// These properties return `true` if the enum's current value matches the case, otherwise `false`.
///
/// ## Usage
/// To use `EnumCaseChecker`, prepend the `@EnumCaseChecker` annotation to your enum declaration.
///
/// ## Example
/// **Before Applying `EnumCaseChecker`:**
/// ```swift
/// enum State {
///     case error(Int)
///     case data
///     case loading
/// }
/// ```
///
/// **After Applying `EnumCaseChecker`:**
/// ```swift
/// @EnumCaseChecker
/// enum State {
///     case error(Int)
///     case data
///     case loading
///
///     // Generated Code
///     var isError: Bool {
///         guard case .error = self else { return false }
///         return true
///     }
///
///     var isData: Bool {
///         guard case .data = self else { return false }
///         return true
///     }
///
///     var isLoading: Bool {
///         guard case .loading = self else { return false }
///         return true
///     }
/// }
/// ```
///
@attached(member, names: arbitrary)
public macro EnumCaseChecker() =
    #externalMacro(module: "AlphaMacroKitMacros", type: "EnumCaseCheckerMacro")
