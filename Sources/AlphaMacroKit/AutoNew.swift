/// `AutoNew` is a macro designed to enhance structs or enums by adding a `new` method. This method initializes
/// the struct or enum with default values, especially useful for types with numerous non-optional properties.
///
/// ## Overview
/// The `AutoNew` macro simplifies the instantiation of structs and enums, providing a `new` method that returns
/// an instance with default values. It's particularly beneficial for types with many properties, streamlining
/// their initialization process.
///
/// ## Usage
/// Apply `AutoNew` by annotating your struct or enum declaration with `@AutoNew`.
///
/// ## Example
/// Here is an example of using `AutoNew` on a `User` struct:
///
/// **Before Applying `AutoNew`:**
/// ```swift
/// struct User {
///     let id: UUID
///     let firstName: String
///     let lastName: String
///     let birthDate: Date?
///
///     var fullName: String {
///         "\(firstName) \(lastName)"
///     }
/// }
/// ```
///
/// **After Applying `AutoNew`:**
/// ```swift
/// @AutoNew
/// struct User {
///     let id: UUID
///     let firstName: String
///     let lastName: String
///     let birthDate: Date?
///
///     var fullName: String {
///         "\(firstName) \(lastName)"
///     }
///
///     // Generated Code
///     static func new(id: UUID = .new(), firstName: String = .new(), lastName: String = .new(), birthDate: Date? = .new()) -> Self {
///         .init(id: id, firstName: firstName, lastName: lastName, birthDate: birthDate)
///     }
/// }
/// ```
///
/// The macro generates a `new` static method for the `User` struct, using `.new()` for default values of non-optional properties.
/// Note: Ensure that all stored properties, especially non-optional ones, implement `static func new() -> Self`.
@attached(member, names: named(new))
public macro AutoNew() = #externalMacro(module: "AlphaMacroKitMacros", type: "AutoNewMacro")
