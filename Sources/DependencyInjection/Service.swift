//
//  Service.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 31/03/25.
//

public protocol Service {
    associatedtype OutputType
    static var output: OutputType { get }
}
