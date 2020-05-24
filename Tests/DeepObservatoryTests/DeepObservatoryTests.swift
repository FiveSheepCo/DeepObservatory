import XCTest
import Combine
@testable import DeepObservatory

class Foo: ObservableObject {
    @Published var list: [Bar] = [] {
        didSet { self.observe(list) }
    }
}

class Bar: ObservableObject, Identifiable {
    @Published var id = UUID()
    @Published var count = 0
    
    func inc() {
        self.count += 1
    }
}

final class DeepObservatoryTests: XCTestCase {
    static var cancellables: [AnyCancellable] = []
    
    func testObservatoryListContainsAddedItem() {
        let foo = Foo()
        let bar = Bar()
        foo.list.append(bar)
        XCTAssertEqual(DeepObservatory.observed.count, 1)
    }
    
    func testObservedListPropagatesChanges() {
        let expectation = XCTestExpectation(description: "Sink called")
        expectation.expectedFulfillmentCount = 2
        let foo = Foo()
        let bar = Bar()
        Self.cancellables.append(foo.objectWillChange.sink { _ in
            expectation.fulfill()
        })
        foo.list.append(bar)
        bar.inc()
        XCTAssertEqual(foo.list[0].count, 1)
        wait(for: [expectation], timeout: 1)
    }

    static var allTests = [
        ("foo", testObservatoryListContainsAddedItem),
        ("foo", testObservedListPropagatesChanges),
    ]
}
