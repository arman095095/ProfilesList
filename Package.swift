// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),
    .package(url: "https://github.com/arman095095/Services.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Managers.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Module.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/DesignSystem.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/AlertManager.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/Utils.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/ProfileRouteMap.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/UserStoryFacade.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/NetworkServices.git", branch: "develop"),
    .package(url: "https://github.com/arman095095/ProfilesListRouteMap.git", branch: "develop"),
]

let package = Package(
    name: "ProfilesList",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ProfilesList",
            targets: ["ProfilesList"]),
    ],
    dependencies: dependencies,
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ProfilesList",
            dependencies: [.product(name: "Services", package: "Services"),
                           .product(name: "DesignSystem", package: "DesignSystem"),
                           .product(name: "AlertManager", package: "AlertManager"),
                           .product(name: "Managers", package: "Managers"),
                           .product(name: "Utils", package: "Utils"),
                           .product(name: "Swinject", package: "Swinject"),
                           .product(name: "ProfileRouteMap", package: "ProfileRouteMap"),
                           .product(name: "ProfilesListRouteMap", package: "ProfilesListRouteMap"),
                           .product(name: "UserStoryFacade", package: "UserStoryFacade"),
                           .product(name: "NetworkServices", package: "NetworkServices")]),
    ]
)
