//
//  DependencyContainer.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 31/03/25.
//

import SwiftUI
import Foundation
import Observation

@Observable
public final class DependencyContainer {

    public init() { }

    public func resolve<T>() -> T? {
        let identifier = ObjectIdentifier(T.self)
        guard let (dependency, lifecycle) = dependencies[identifier] else {
            return nil
        }

        switch lifecycle {
            case .singleton:
                if let resolved = resolvedSingletons[identifier] as? T {
                    return resolved
                } else if let resolved = dependency as? T {
                    resolvedSingletons[identifier] = resolved
                    return resolved
                } else {
                    return nil
                }
            case .transient:
                return dependency as? T
        }
    }

    public func resolveOrFatal<T>() -> T? {
        guard let resolved: T = resolve() else {
#if DEBUG
            debugPrint("Dependency \(T.self) not registered")
#endif
            return nil
        }
        return resolved
    }

    public func register<T>(
        _ dependency: T,
        _ lifecycle: DependencyLifecycle = .transient
    ) {
        dependencies[ObjectIdentifier(T.self)] = (dependency, lifecycle)
    }

    public func disposeSingletons() {
        resolvedSingletons.removeAll()
    }

    private var dependencies: [ObjectIdentifier: (Any, DependencyLifecycle)] = [:]
    private var resolvedSingletons: [ObjectIdentifier: Any] = [:]
}
