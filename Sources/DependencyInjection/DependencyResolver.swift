//
//  DependencyResolver.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 02/04/25.
//

public protocol DependencyResolver {
    func resolve<T>() -> T?
    func resolveOrFatal<T>() throws -> T
}
