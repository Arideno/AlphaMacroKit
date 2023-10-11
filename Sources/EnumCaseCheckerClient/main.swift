import EnumCaseChecker

@EnumCaseChecker
enum State {
    case error(Int)
    case data
    case loading
}

let state = State.loading

print(state.isLoading)
