// Henrik Top Mygind, 17/06/2022

import XCTest
import Combine
import Utils
import CombineUtils

class Publisher_AsyncTests: XCTestCase {

    class MockService {
        func doSoon(waitTimeInNanosecond: UInt64 = 0, _ action: @escaping () -> Void) {
            Task {
                try? await Task.sleep(nanoseconds: waitTimeInNanosecond)
                action()
            }
        }
    }
    
    // MARK: Async
    func test_asyncWorks() async {
        let publisher = PassthroughSubject<Int, Never>()
        MockService().doSoon {
            publisher.send(42)
        }
        
        let value = await publisher.async()
        XCTAssertEqual(42, value)
    }
    
    func test_asyncOnlySendsFirstOnly() async {
        let publisher = PassthroughSubject<Int, Never>()
        MockService().doSoon {
            publisher.send(42)
            publisher.send(32)
        }
        
        let value = await publisher.async()
        XCTAssertEqual(42, value)
    }
    
    func test_asyncTimeoutWorks() async {
        let publisher = PassthroughSubject<Int, Never>()
        MockService().doSoon {
            publisher.send(42)
        }
        
        let value = await publisher.async(timeout: .milliseconds(10))
        XCTAssertEqual(42, value)
    }
    
    // MARK: AsyncTimeout
    func test_asyncTimeout_willTimeout() async {
        let publisher = PassthroughSubject<Int, Never>()
        
        let value = await publisher.async(timeout: .milliseconds(10))
        XCTAssertEqual(nil, value)
    }
    
    func test_asyncTimeout_willTimeoutBeforeValueIsSend() async {
        let publisher = PassthroughSubject<Int, Never>()
        
        MockService().doSoon(waitTimeInNanosecond: UInt64(0.1.inNano)) {
            publisher.send(42)
        }
        let value = await publisher.async(timeout: .milliseconds(10))
        XCTAssertEqual(nil, value)
    }
    
    func test_asyncTimeout_willSendValueBeforeTimeout() async {
        let publisher = PassthroughSubject<Int, Never>()
        
        MockService().doSoon(waitTimeInNanosecond: UInt64(0.001.inNano)) {
            publisher.send(42)
        }
        let value = await publisher.async(timeout: .milliseconds(10))
        XCTAssertEqual(42, value)
    }
    
    func test_asyncTimeout_canTimeoutAndSendValue() async {
        let publisher = PassthroughSubject<Int, Never>()
        
        MockService().doSoon(waitTimeInNanosecond: UInt64(0.02.inNano)) {
            publisher.send(42)
        }
        
        async let impatient = await publisher.async(timeout: .milliseconds(10))
        async let patient = await publisher.async(timeout: .milliseconds(30))
        
        let impatientResult = await impatient
        let patientResult = await patient
        
        XCTAssertEqual(patientResult, 42)
        XCTAssertEqual(impatientResult, nil)
    }
}
