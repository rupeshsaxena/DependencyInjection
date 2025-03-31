Dependency Injection Framework

A lightweight, modular and scalable dependency injection framework for Swift.

Features:

Modular Architecture: Organize your dependencies into separate modules to improve maintainability and reusability.
Service Registration: Register services with their respective instances or implementations.
Service Resolution: Resolve services by type or name using a simple API.
Scalable: Designed to handle large applications with multiple services.
Getting Started:

Add the DependencyInjector framework to your project.
Create a module for each service in your application (e.g., DataService, UserService, etc.).
Register the services in your main application class or using a service registry.
Resolve services as needed using the resolve() function.
Example Use Case:

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
Installation:

To use this framework, simply add it to your project's dependencies using Swift Package Manager (SPM).

git clone https://github.com/your-username/Dependency-Injector.git
swift build --target xcodeproj
open DependencyInjector.xcodeproj
Note that you'll need to replace your-username with your actual GitHub username.

Contributing:

Feel free to contribute to this framework by opening issues or pull requests. Your help is greatly appreciated!

License:

This project is licensed under the MIT License. See LICENSE for more information.
