import Testing
import Foundation
@testable import DependencyInjection

final class DependencyInjectionTests {
    private var container: DependencyContainer!

    init() {
        container = DependencyContainer()
    }

    deinit {
        container = nil
    }

    @Test
    func testSingletonRegistrationAndResolution() {
        // Register as singleton with instance
        let mockDataService = MockDataService()
        container.register(mockDataService as DataService, .singleton)

        let resolved1: DataService? = container.resolve()
        let resolved2: DataService? = container.resolve()

        #expect(resolved1 != nil)
        #expect(resolved1 is MockDataService)
        #expect(resolved1?.fetchData() == "bar")

        // Singletons should return the same instance
        #expect(resolved1 as AnyObject === resolved2 as AnyObject)
    }

    @Test
    func testTransientRegistrationCreatesNewInstances() {
        // Register with factory for proper transient behavior
        container.register(.transient) {
            MockUserService() as UserService
        }

        let resolved1: UserService? = container.resolve()
        let resolved2: UserService? = container.resolve()

        #expect(resolved1 != nil)
        #expect(resolved2 != nil)
        #expect(resolved1?.getUsername() == "foo")
        #expect(resolved2?.getUsername() == "foo")

        // Transients should create different instances
        #expect(resolved1 as AnyObject !== resolved2 as AnyObject)
    }

    @Test
    func testFactoryRegistrationWithSingleton() {
        // Register with factory as singleton
        var callCount = 0
        container.register(.singleton) {
            callCount += 1
            return MockDataService() as DataService
        }

        let resolved1: DataService? = container.resolve()
        let resolved2: DataService? = container.resolve()

        // Factory should only be called once for singleton
        #expect(callCount == 1)
        #expect(resolved1 as AnyObject === resolved2 as AnyObject)
    }

    @Test
    func testResolveSafelyReturnsNilForUnregistered() {
        let mockService: MockUserService? = container.resolveSafely()
        #expect(mockService == nil)
    }

    @Test
    func testResolveReturnsNilForUnregistered() {
        let mockService: MockUserService? = container.resolve()
        #expect(mockService == nil)
    }

    @Test
    func testResolveOrThrowThrowsForUnregistered() {
        #expect(throws: DependencyError.self) {
            let _: MockUserService = try container.resolveOrThrow()
        }
    }

    @Test
    func testResolveOrThrowSucceedsForRegistered() throws {
        container.register(MockDataService() as DataService)

        let resolved: DataService = try container.resolveOrThrow()
        #expect(resolved.fetchData() == "bar")
    }

    @Test
    func testDisposeSingletonsRemovesCachedInstances() {
        var callCount = 0
        container.register(.singleton) {
            callCount += 1
            return MockDataService() as DataService
        }

        // First resolution creates singleton
        let _: DataService? = container.resolve()
        #expect(callCount == 1)

        // Second resolution uses cached instance
        let _: DataService? = container.resolve()
        #expect(callCount == 1)

        // Dispose singletons
        container.disposeSingletons()

        // Next resolution creates new instance
        let _: DataService? = container.resolve()
        #expect(callCount == 2)
    }

    @Test
    func testUnregisterRemovesDependency() {
        container.register(MockDataService() as DataService)

        var resolved: DataService? = container.resolve()
        #expect(resolved != nil)

        container.unregister(DataService.self)

        resolved = container.resolve()
        #expect(resolved == nil)
    }

    @Test
    func testResetClearsAllDependencies() {
        container.register(MockDataService() as DataService)
        container.register(MockUserService() as UserService)

        container.reset()

        let dataService: DataService? = container.resolve()
        let userService: UserService? = container.resolve()

        #expect(dataService == nil)
        #expect(userService == nil)
    }

    @Test
    func testThreadSafetyConcurrentReads() async {
        container.register(.singleton) {
            MockDataService() as DataService
        }

        let containerRef = container!
        await withTaskGroup(of: Bool.self) { group in
            for _ in 0..<100 {
                group.addTask {
                    let resolved: DataService? = containerRef.resolve()
                    return resolved != nil
                }
            }

            var successCount = 0
            for await success in group {
                if success { successCount += 1 }
            }

            #expect(successCount == 100)
        }
    }

    @Test
    func testThreadSafetyConcurrentWrites() async {
        let containerRef = container!
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<50 {
                group.addTask {
                    containerRef.register(.transient) {
                        MockDataService() as DataService
                    }
                }
            }

            await group.waitForAll()
        }

        // Should successfully resolve after concurrent registrations
        let resolved: DataService? = container.resolve()
        #expect(resolved != nil)
    }
}
