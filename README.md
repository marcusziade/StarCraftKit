# StarCraftKit
<a href="https://wakatime.com/badge/user/52d828f5-807b-496a-bfc0-5dbef43c05e5/project/018de122-9301-4e14-a56f-4a6e87034a5d"><img src="https://wakatime.com/badge/user/52d828f5-807b-496a-bfc0-5dbef43c05e5/project/018de122-9301-4e14-a56f-4a6e87034a5d.svg" alt="wakatime"></a>

Welcome to StarCraftKit, a Swift package tailored for developers engaged in creating apps or tools focused on the professional StarCraft II scene. This package provides a robust set of interfaces designed to streamline the handling, querying, and presentation of data related to players, matches, and tournaments within the StarCraft II pro scene.

## About StarCraftKit

StarCraftKit offers Swift interfaces for the pro StarCraft II scene, making it easier to integrate professional game data into your applications. Whether you're building an app to display live match updates, track player statistics, or organize tournament information, StarCraftKit has the tools you need to get the job done efficiently and effectively.

## Features

-   **Player Profiles**: Access detailed profiles of professional StarCraft II players, including statistics, current status, and match history.
-   **Match Details**: Query information about specific matches, including player matchups, game results, and detailed statistical analysis.
-   **Tournament Data**: Explore comprehensive details about past, ongoing, and upcoming tournaments, including brackets, match schedules, and winner information.

## Getting Started

To start using StarCraftKit in your project, ensure you have Swift 5.7 or later and add the package to your project dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/StarCraftKit.git", from: "1.0.0")
]
```

Then, import StarCraftKit in your Swift files to access its functionalities:

```swift
import StarCraftKit
```

## Environment Variables in Xcode

To securely access the PandaScore API, which powers the package, you'll need to use an API token. Upon signing up with PandaScore, you're given a unique token.

### Setting Up Environment Variables in Xcode

1. **Create an Environment Variable for Your Token**: Open your project in Xcode, select your application target, and go to the "Edit Scheme" menu. Under the "Run" section, find the "Arguments" tab. Here, you can add environment variables. Create a new variable named `PANDASCORE_API_TOKEN` and set its value to your PandaScore API token.

The package will look for this key in the code, so that's all you need to do manually, for now...

## Contribution

StarCraftKit is under development, contributions are welcome. If you have ideas for improvements, find a bug, or want to add new features, feel free to open an issue or submit a pull request.

## License

StarCraftKit is released under the MIT License.
