// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "AlphaMacroKit",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "AlphaMacroKit",
            targets: ["AlphaMacroKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/stackotter/swift-macro-toolkit", from: "0.3.1"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.2.1"),
    ],
    targets: [
        .macro(
            name: "AlphaMacroKitMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "MacroToolkit", package: "swift-macro-toolkit"),
            ]
        ),
        .target(name: "AlphaMacroKit", dependencies: ["AlphaMacroKitMacros"]),
        .testTarget(
            name: "AlphaMacroKitTests",
            dependencies: [
                "AlphaMacroKitMacros",
                .product(name: "MacroTesting", package: "swift-macro-testing"),
            ]
        ),
        .executableTarget(name: "AlphaMacroKitClient", dependencies: ["AlphaMacroKit"]),
    ]
)
