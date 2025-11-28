# Dependency Injection Framework

A lightweight, thread-safe, and type-safe dependency injection framework for Swift with SwiftUI integration.

## Features

*   **Type-Safe**: Leverage Swift's type system for compile-time safety
*   **Thread-Safe**: Built-in locking mechanism for concurrent access
*   **Lifecycle Management**: Support for singleton and transient dependencies
*   **Factory Pattern**: Register dependencies using closures for lazy instantiation
*   **SwiftUI Integration**: Seamless injection using property wrappers
*   **Error Handling**: Comprehensive error types for debugging
*   **Observable**: SwiftUI-ready with `@Observable` macro support

## Requirements

- iOS 17.0+ / macOS 14.0+
- Swift 6.0+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add this to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/DependencyInjection.git", from: "1.0.0")
]
```

## Usage

### 1. Define Your Services

```swift
protocol DataService {
    func fetchData() -> String
}

class APIDataService: DataService {
    func fetchData() -> String {
        return "Data from API"
    }
}
```

### 2. Register Dependencies

Create a container and register your dependencies:

```swift
let container = DependencyContainer()

// Register as singleton (instance reused)
container.register(APIDataService() as DataService, .singleton)

// Register with factory as transient (new instance each time)
container.register(.transient) {
    APIDataService() as DataService
}

// Register with factory as singleton (lazy initialization)
container.register(.singleton) {
    APIDataService() as DataService
}
```

### 3. Resolve Dependencies

```swift
// Optional resolution
if let service: DataService = container.resolve() {
    print(service.fetchData())
}

// Safe resolution with debug logging
let service: DataService? = container.resolveSafely()

// Throwing resolution
do {
    let service: DataService = try container.resolveOrThrow()
    print(service.fetchData())
} catch {
    print("Dependency not registered: \(error)")
}
```

### 4. SwiftUI Integration

Inject the container into your SwiftUI app:

```swift
@main
struct MyApp: App {
    let container = DependencyContainer()

    init() {
        // Register all dependencies
        container.register(APIDataService() as DataService, .singleton)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(container)
        }
    }
}
```

Use the `@Inject` property wrapper in your views:

```swift
struct ContentView: View {
    @Inject var dataService: DataService

    var body: some View {
        Text(dataService.fetchData())
    }
}
```

For optional dependencies that might not be registered:

```swift
struct ContentView: View {
    @InjectOptional var optionalService: DataService?

    var body: some View {
        if let service = optionalService {
            Text(service.fetchData())
        } else {
            Text("Service not available")
        }
    }
}
```

## Advanced Features

### Lifecycle Management

```swift
// Dispose all singleton instances (keeps registrations)
container.disposeSingletons()

// Unregister a specific dependency
container.unregister(DataService.self)

// Clear all registrations and instances
container.reset()
```

### Factory with Custom Logic

```swift
container.register(.transient) {
    let service = APIDataService()
    service.configure(apiKey: "your-api-key")
    return service as DataService
}
```

### Testing

The framework is fully thread-safe and includes comprehensive tests:

```swift
// Create a test container
let container = DependencyContainer()

// Register mocks
container.register(MockDataService() as DataService, .singleton)

// Verify behavior
let service: DataService = try container.resolveOrThrow()
XCTAssertNotNil(service)
```

## Architecture

- **DependencyContainer**: Main container managing registrations and resolutions
- **DependencyLifecycle**: Enum defining singleton or transient lifecycles
- **DependencyError**: Error types for dependency resolution failures
- **@Inject**: Property wrapper for automatic dependency injection in SwiftUI
- **@InjectOptional**: Property wrapper for optional dependency injection

## Thread Safety

All container operations are protected by `NSLock`, ensuring safe concurrent access:

```swift
// Safe to call from multiple threads
DispatchQueue.concurrentPerform(iterations: 100) { _ in
    let service: DataService? = container.resolve()
}
```

## Best Practices

1. **Register early**: Register all dependencies at app startup
2. **Use singletons for shared state**: Database, network clients, etc.
3. **Use transients for stateful objects**: View models, temporary services
4. **Use factories for lazy initialization**: Heavy objects that might not be needed
5. **Test with mocks**: Easy to swap implementations for testing

## Contributing

Contributions are welcome! Please open an issue or pull request.

## License

This project is licensed under the MIT License. See `LICENSE` for more information.
