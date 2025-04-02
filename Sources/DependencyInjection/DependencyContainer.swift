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
public final class DependencyContainer: DependencyResolver, DependencyRegistrar {
    public func resolve<T>() -> T? {
        dependencies[ObjectIdentifier(T.self)] as? T
    }

    public func resolveOrFatal<T>() throws -> T {
        guard let resolved: T = dependencies[ObjectIdentifier(T.self)] as? T else {
            throw NSError(domain: "Dependency is not registered", code: -101)
        }
        return resolved
    }

    public func register<T>(_ dependency: T) {
        dependencies[ObjectIdentifier(T.self)] = dependency
    }

    private var dependencies: [ObjectIdentifier: Any] = [:]
}
