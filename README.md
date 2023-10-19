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

## Alternatives

1Password's CLI tool can pass secrets from 1Password to scripts and commands. For example, `op run --env-file tf.env -- terraform init` where `tf.env` looks like this:

```
AWS_ACCESS_KEY_ID="op://MyVault/Terraform/access-key"
AWS_SECRET_KEY="op://MyVault/Terraform/secret-key"
```

The `op://` links are references to secrets. `op run` runs `terraform init` in a sub-process with the actual values of the secrets in the sub-process's environment.

Here is the documentation https://developer.1password.com/docs/cli/reference/commands/run/
