//
//  MockServiceProvider.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 31/03/25.
//
import DependencyInjection
import Foundation

public class MockServiceProvider: ServiceProvider, Equatable {
    public typealias OutputType = MockService

    public static let name: String = "MockServiceProvider"

    public func resolve() -> OutputType.OutputType {
        OutputType.output
    }

    public static func == (lhs: MockServiceProvider, rhs: MockServiceProvider) -> Bool {
        lhs.resolve() == rhs.resolve()
    }
}
