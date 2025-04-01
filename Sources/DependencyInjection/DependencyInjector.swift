//
//  DependencyInjector.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 31/03/25.
//

import Foundation

internal class DependencyInjector {
    private var providers: [String: any ServiceProvider] = [:]

    func register<T>(_ service: T) where T: ServiceProvider {
        let key = String(describing: T.self)
        dump(key)
        providers[key] = service
        dump(providers)
    }

    func resolve<T>() throws -> T? where T: ServiceProvider {
        let key = String(describing: T.self)
        dump(key)
        guard let serviceProvider = providers[key] else {
            throw NSError(domain: "No service provider registered", code: -102)
        }
        return serviceProvider as? T
    }
}
