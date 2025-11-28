//
//  DependencyContainer.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 31/03/25.
//

import SwiftUI
import Foundation
import Observation

/// Errors that can occur during dependency resolution
public enum DependencyError: Error, CustomStringConvertible {
    case notRegistered(String)
    case resolutionFailed(String)

    public var description: String {
        switch self {
        case .notRegistered(let type):
            return "Dependency not registered: \(type)"
        case .resolutionFailed(let type):
            return "Failed to resolve dependency: \(type)"
        }
    }
}

@Observable
public final class DependencyContainer: @unchecked Sendable {

    private let lock = NSLock()
    private var factories: [ObjectIdentifier: () -> Any] = [:]
    private var lifecycles: [ObjectIdentifier: DependencyLifecycle] = [:]
    private var resolvedSingletons: [ObjectIdentifier: Any] = [:]

    public init() { }

    /// Resolves a dependency by type, returning nil if not found
    public func resolve<T>() -> T? {
        lock.lock()
        defer { lock.unlock() }

        let identifier = ObjectIdentifier(T.self)
        guard let factory = factories[identifier],
              let lifecycle = lifecycles[identifier] else {
            return nil
        }

        switch lifecycle {
        case .singleton:
            // Return cached singleton if exists
            if let cached = resolvedSingletons[identifier] as? T {
                return cached
            }
            // Create and cache new singleton
            let instance = factory()
            guard let typedInstance = instance as? T else {
                return nil
            }
            resolvedSingletons[identifier] = typedInstance
            return typedInstance

        case .transient:
            // Always create new instance
            return factory() as? T
        }
    }

    /// Resolves a dependency, throwing an error if not found
    public func resolveOrThrow<T>() throws -> T {
        guard let resolved: T = resolve() else {
            throw DependencyError.notRegistered(String(describing: T.self))
        }
        return resolved
    }

    /// Resolves a dependency safely, printing debug info if not found
    public func resolveSafely<T>() -> T? {
        guard let resolved: T = resolve() else {
#if DEBUG
            debugPrint("⚠️ Dependency \(T.self) not registered")
#endif
            return nil
        }
        return resolved
    }

    /// Registers a dependency with a factory closure
    public func register<T>(
        _ lifecycle: DependencyLifecycle = .transient,
        factory: @escaping () -> T
    ) {
        lock.lock()
        defer { lock.unlock() }

        let identifier = ObjectIdentifier(T.self)
        factories[identifier] = factory
        lifecycles[identifier] = lifecycle

        // Clear any cached singleton if re-registering
        resolvedSingletons.removeValue(forKey: identifier)
    }

    /// Convenience method to register an existing instance
    public func register<T>(
        _ instance: T,
        _ lifecycle: DependencyLifecycle = .singleton
    ) {
        register(lifecycle) { instance }
    }

    /// Removes all cached singleton instances (keeps registrations)
    public func disposeSingletons() {
        lock.lock()
        defer { lock.unlock() }

        resolvedSingletons.removeAll()
    }

    /// Unregisters a specific dependency type
    public func unregister<T>(_ type: T.Type) {
        lock.lock()
        defer { lock.unlock() }

        let identifier = ObjectIdentifier(type)
        factories.removeValue(forKey: identifier)
        lifecycles.removeValue(forKey: identifier)
        resolvedSingletons.removeValue(forKey: identifier)
    }

    /// Clears all registrations and cached instances
    public func reset() {
        lock.lock()
        defer { lock.unlock() }

        factories.removeAll()
        lifecycles.removeAll()
        resolvedSingletons.removeAll()
    }
}
