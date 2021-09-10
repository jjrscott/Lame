//
//  XCTestCase+Expectation.swift
//  LameTests
//
//  Created by John Scott on 9/10/21.
//  Copyright © 2021 John Scott. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func wait(timeout seconds: TimeInterval, file: StaticString = #file, line: UInt = #line, block: (XCTestExpectation) -> ()) {
        
        let expectation = XCTestExpectation()
        block(expectation)
        wait(for: [expectation], timeout: seconds)
    }
}

extension XCTWaiter {
    class func wait(timeout seconds: TimeInterval, file: StaticString = #file, line: UInt = #line, block: (XCTestExpectation) -> ()) -> XCTWaiter.Result {
        
        let expectation = XCTestExpectation()
        block(expectation)
        return wait(for: [expectation], timeout: seconds)
    }
}
