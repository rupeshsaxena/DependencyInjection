//
//  Inject.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 03/04/25.
//

import SwiftUI

/// Property wrapper for injecting dependencies in SwiftUI views
@propertyWrapper
public struct Inject<T>: DynamicProperty {
    @Environment(DependencyContainer.self) private var container

    public var wrappedValue: T {
        guard let dependency: T = container.resolve() else {
            fatalError("❌ Dependency '\(T.self)' is not registered in the container. Please register it before use.")
        }
        return dependency
    }

    public init() {}
}

/// Property wrapper for optional dependency injection (won't crash if not registered)
@propertyWrapper
public struct InjectOptional<T>: DynamicProperty {
    @Environment(DependencyContainer.self) private var container

    public var wrappedValue: T? {
        container.resolveSafely()
    }

    public init() {}
}
