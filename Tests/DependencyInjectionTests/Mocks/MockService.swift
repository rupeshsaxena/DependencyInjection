//
//  MockService.swift
//  DependencyInjection
//
//  Created by Rupesh Saxena on 31/03/25.
//

import DependencyInjection
import Foundation

public class MockService: Service {
    public typealias OutputType = String

    public static var outputKind: String {
        "MockService"
    }

    public static var output: String {
        outputKind
    }
}
