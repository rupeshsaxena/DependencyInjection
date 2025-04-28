//
//  MockService.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 31/03/25.
//

import DependencyInjection
import Foundation

public protocol DataService {
    func fetchData() -> String
}

public protocol UserService {
    func getUsername() -> String
}

public class MockDataService: DataService {
    public func fetchData() -> String {
        "bar"
    }
}

public class MockUserService: UserService {
    public func getUsername() -> String {
        "foo"
    }
}
