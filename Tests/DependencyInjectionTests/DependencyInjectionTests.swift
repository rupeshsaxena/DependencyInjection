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

        container.register(mockDataService as DataService)
        container.register(mockUserService as UserService)

        let resolvedDataService: DataService? = container.resolve()
        var resolvedUserService: UserService
        do {
            resolvedUserService = try container.resolveOrFatal()
            #expect(resolvedUserService is MockUserService)
            #expect(resolvedUserService.getUsername() == "Mock user name")
        } catch {}

        #expect(resolvedDataService != nil)
        #expect(resolvedDataService is MockDataService)

        #expect(resolvedDataService!.fetchData() == "Mocked Data")

    }

    @Test
    func containerResolvesServiceProviderWithoutRegistration() throws {
        do {
            let _: MockUserService! = try container.resolveOrFatal()
        } catch let error as NSError {
            #expect(error.code == -102)
        }
    }
}
