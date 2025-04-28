//
//  Inject.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 03/04/25.
//

import SwiftUI

@propertyWrapper
public struct Inject<T>: DynamicProperty {
    @Environment(DependencyContainer.self) private var resolver

    public var wrappedValue: T {
        resolver.resolveOrFatal() ?? resolver.resolve()!
    }

    public init() {}
}
