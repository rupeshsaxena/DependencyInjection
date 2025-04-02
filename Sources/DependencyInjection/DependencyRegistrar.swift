//
//  DependencyRegistrar.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 02/04/25.
//

public protocol DependencyRegistrar {
    func register<T>(_ dependency: T)
}
