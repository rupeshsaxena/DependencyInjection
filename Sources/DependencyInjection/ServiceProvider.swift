//
//  ServiceProvider.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 31/03/25.
//

import Foundation

public protocol ServiceProvider {
    static var name: String { get }
    associatedtype OutputType: Service
    func resolve() -> OutputType.OutputType
}
