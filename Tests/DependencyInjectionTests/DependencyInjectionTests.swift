import Testing
import Foundation
@testable import DependencyInjection

final class DependencyInjectionTests {
    private var dependencyContainer: DependencyContainer!
    private var mockServiceProvider: MockServiceProvider!
    private var mockService: MockService!

    init() throws {
        dependencyContainer = DependencyContainer()
        mockServiceProvider = MockServiceProvider()
        mockService = MockService()
    }

    deinit {
        dependencyContainer = nil
        mockServiceProvider = nil
        mockService = nil
    }

    @Test
    func containerRegisterServiceProvider() throws { dependencyContainer.registerService(mockServiceProvider)

        let expectedRegistry: MockServiceProvider! = try dependencyContainer.resolveService()

        #expect(expectedRegistry != nil)
    }

    @Test
    func containerRegisterServiceProviderAndThenResolveTheServiceProvider() throws {
        dependencyContainer.registerService(mockServiceProvider)
        let expectedProvider: MockServiceProvider! = try dependencyContainer.resolveService()
        let mockService = mockServiceProvider.resolve()
        let expectedMockService = expectedProvider.resolve()

        #expect(mockServiceProvider == expectedProvider)
        #expect(mockService == expectedMockService)
    }

    @Test
    func containerResolvesServiceProviderWithoutRegistration() throws {
        do {
            let _: MockServiceProvider! = try dependencyContainer.resolveService()
        } catch let error as NSError {
            #expect(error.code == -102)
        }
    }
}
