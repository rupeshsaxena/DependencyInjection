# Dependency Injection Framework
==============================

A lightweight, modular and scalable dependency injection framework for Swift.

## Features
------------

*   **Modular Architecture**: Organize your dependencies into separate modules to improve maintainability and reusability.
*   **Service Registration**: Register services with their respective instances or implementations.
*   **Service Resolution**: Resolve services by type or name using a simple API.
*   **Scalable**: Designed to handle large applications with multiple services.

## Getting Started
-----------------

### Step 1: Add the Dependency Injection Framework

Add the `DependencyInjection` framework to your project.

### Step 2: Create Modules for Your Services

Create a module for each service in your application (e.g., `DataService`, `UserService`, etc.).

### Step 3: Register and Resolve Services

Register the services in your main application class or using a service registry. Then, resolve services as needed using the `resolve()` function.

## Example Use Case
--------------------

```swift
class AppServiceProvider: ServiceProvider {
    static var type: String { return "AppServiceProvider" }

    let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
    }
}

let appServiceProvider = AppServiceProvider(dataService: DefaultDataService())
DependencyInjector().registerModule(appServiceProvider)

// Resolve the service later...
let resolvedService = DependencyInjector().resolve()
```

## Installation
---------------

To use this framework, follow these steps:

1.  Clone the repository using Git.
2.  Build the project using Swift Package Manager (SPM).
3.  Open the generated Xcode project.

```bash
git clone https://github.com/your-username/Dependency-Injector.git
swift build --target xcodeproj
open DependencyInjector.xcodeproj
```

Note that you'll need to replace `your-username` with your actual GitHub username.

## Contributing
---------------

Feel free to contribute to this framework by opening issues or pull requests. Your help is greatly appreciated!

## License
----------

This project is licensed under the MIT License. See `LICENSE` for more information.
