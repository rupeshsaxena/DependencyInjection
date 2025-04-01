//
//  DependencyContainer.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 31/03/25.
//

import Foundation

public class DependencyContainer {
    let injector: DependencyInjector

    public init() {
        self.injector = DependencyInjector()
    }

    public func registerService<T>(_ service: T) where T: ServiceProvider {
        injector.register(service)
    }

    public func resolveService<T>() throws -> T? where T: ServiceProvider {
        return try injector.resolve()
    }
}
