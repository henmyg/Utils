import XCTest
import Utils

final class WeakTests: XCTestCase {
    
    class Example {
    }
    
    func test_doesntKeepValueAlive()  {
        var strongExample: Example? = Example()
        weak var weakExample = strongExample
        let _ = Weak(strongExample!)
        
        XCTAssertNotNil(weakExample)
        strongExample = nil
        XCTAssertNil(weakExample)
    }
}
