import Testing
import Foundation
@testable import DependencyInjection

final class DependencyInjectionTests {
    private var container: DependencyContainer!
    private var mockDataService: MockDataService!
    private var mockUserService: MockUserService!

    init() {
        container = DependencyContainer()
        mockDataService = MockDataService()
        mockUserService = MockUserService()
    }

    deinit {
        container = nil
        mockDataService = nil
        mockUserService = nil
    }

    @Test
    func testDependencyRegistrationAndResolution() {

        container.register(mockDataService as DataService, .singleton)
        container.register(mockUserService as UserService, .transient)

        let resolvedDataService: DataService? = container.resolve()
        let resolvedUserService: UserService? = container.resolveOrFatal()

        #expect(resolvedUserService is MockUserService)
        #expect(resolvedUserService?.getUsername() == "foo")
        #expect(resolvedDataService != nil)
        #expect(resolvedDataService is MockDataService)

        #expect(resolvedDataService!.fetchData() == "bar")
    }

    @Test
    func containerResolvesServiceProviderWithoutRegistration() {
        let mockService: MockUserService? = container.resolveOrFatal()
        #expect(mockService == nil)
    }
}
