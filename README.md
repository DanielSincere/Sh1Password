# Sh1Password

Sh plugin of 1Password CLI. Requires version 2 of the 1Password CLI, available from https://1password.com/downloads/command-line/

Sh is a tool for running command line tools from Swift programs. Find out more about Sh from https://github.com/FullQueueDeveloper/Sh

## Example

### Example usage

Fetch a key out of 1Password and upload it to Heroku secret config variables.

    import Sh1Password
    import Sh

    let op = OP()

    // fetch key
    let key = try op.get(item: "Server",
                         vault: "MyProjectVault",
                         section: "Signing Keys",
                         field: "JWT Signing Key")

    // upload to heroku
    let environment: [String: String] = [
        "JWT_SIGNING_KEY": key
    ]

    let cmd: String = #"heroku config:set JWT_SIGNING_KEY="$JWT_SIGNING_KEY""#

    try sh(.terminal, cmd, enviroment: environment)

### Example `Package.swift`

    // swift-tools-version:5.6

    import PackageDescription

    let package = Package(
        name: "Scripts",
        platforms: [.macOS(.v12)],
        dependencies: [
          .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.0.0"),
          .package(url: "https://github.com/FullQueueDeveloper/Sh1Password.git", from: "0.1.1"),
        ],
        targets: [
            .executableTarget(
                name: "heroku-env",
                dependencies: [
                    "Sh", "Sh1Password",
                ]),
        ]
    )
