import AlphaMacroKit
import Foundation

@AutoNew
@EnumCaseChecker
enum State {
    case error(Int)
    case data
    case loading
}

let state = State.loading

print(state.isLoading)

@AutoNew
struct User {
    let id: UUID
    let firstName: String
    let lastName: String
    let birthDate: Date?
    let state: State

    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

print(User.new())
