//
//  LameTests.swift
//  LameTests
//
//  Created by John Scott on 12/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import XCTest
@testable import Lame

class LameTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testRequestTrending() throws {
        let semaphore = ResultSemaphore<[TheMovieDatabase.TrendingResult],Error>()

        let client = TheMovieDatabase()
        
        client.requestTrending { result in
            semaphore.signal(result)
        }
        
        do {
            let result = try semaphore.wait()
            XCTAssertGreaterThan(result.count, 0)
        } catch let error {
            XCTAssertNil(error)
        }
    }


}
