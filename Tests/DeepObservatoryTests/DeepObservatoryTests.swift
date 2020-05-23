import XCTest
@testable import DeepObservatory

final class DeepObservatoryTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DeepObservatory().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
