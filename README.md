# 🐺 AlphaMacroKit

[![CI](https://github.com/Arideno/AlphaMacroKit/workflows/CI/badge.svg)](https://actions-badge.atrox.dev/Arideno/AlphaMacroKit/goto)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FArideno%2FAlphaMacroKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Arideno/AlphaMacroKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FArideno%2FAlphaMacroKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Arideno/AlphaMacroKit)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

AlphaMacroKit is crafted to enhance Swift development by providing useful Swift macros. For now this library introduces `AutoNew` and `EnumCaseChecker` macros to solve specific challenges in unit testing area.

- [Requirements](#requirements)
- [Installation](#installation)
  - [SPM](#swift-package-manager)
- [Usage](#usage)
- [Documentation](#documentation)
- [Feedback](#feedback)
- [Support Open Source](#support-open-source)
- [License](#license)

## Requirements

- iOS 13.0+
- macOS 10.15+
- watchOS 6.0+
- tvOS 13.0+
- Swift 5.9+

## Installation

### Swift Package Manager

In Xcode:

- Click project ⭢ Under projects tab select your project ⭢ Package Dependencies ⭢ Plus icon
- Use this URL https://github.com/Arideno/AlphaMacroKit

In Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/Arideno/AlphaMacroKit", from: "0.1.0")
]
```

## Usage

The AutoNew macro dramatically simplifies the creation of instances, especially for structs and enums with multiple non-optional properties. It generates a new method, providing default values and reducing boilerplate code. This is useful in unit testing as you usually need to create some stub structs for tests. For example:

```swift
@AutoNew
struct User {
    let id: UUID
    let name: String
    // Other properties
}

let newUser = User.new()
let newUser2 = User.new(name: "Test name")
```

Similarly, EnumCaseChecker enhances enums by adding computed properties for each case, allowing for more readable and maintainable code. This is particularly useful in unit testing scenarios where enum states are frequently checked. Example:

```swift
@EnumCaseChecker
enum State {
    case loading
    case success
    case error(String)
}

let state = State.loading
print(state.isLoading) // true
```

These macros aim to streamline Swift development, making code more concise and expressive, and significantly improving the unit testing experience.

## Documentation

The latest documentation for CasePaths' APIs is available
[here](https://swiftpackageindex.com/Arideno/AlphaMacroKit/main/documentation/alphamacrokit).

## Feedback

If you happen to encounter any problem or you have any suggestion, please, don't hesitate to open an issue or reach out to me at [andrii.moisol@gmail.com](andrii.moisol@gmail.com).
This is an open source code project, so feel free to collaborate by raising a pull-request or sharing your feedback.

## Support Open Source

If you love this library, understand all the effort it takes to maintain it and would like to support me, you can buy me a coffee by following this [link](https://www.buymeacoffee.com/andriimoisol):

<a href="https://www.buymeacoffee.com/andriimoisol" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>

You can also sponsor me by hitting the [_GitHub Sponsor_](https://github.com/sponsors/Arideno) button. All help is very much appreciated.

## License

`AlphaMacroKit` is available under the MIT license. See the [LICENSE](/LICENSE) file for more info.
