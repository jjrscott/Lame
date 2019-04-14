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
    
    enum TestError: Error {
        case noPosters
    }

    override func setUp() {
    }

    override func tearDown() {
    }

    func testTrendingRequest() {
        let semaphore = ResultSemaphore<[TheMovieDatabase.TrendingResult],Error>()

        let client = TheMovieDatabase()
        
        client.requestTrending(result: semaphore.signal)
        
        do {
            let result = try semaphore.wait()
            XCTAssertGreaterThan(result.count, 0)
        } catch let error {
            XCTAssertNil(error)
        }
    }

    func testPosterRequest() throws {
        let semaphore = ResultSemaphore<Data,Error>()

        let client = TheMovieDatabase()
        
        client.requestTrending { result in
            result.pipe(to: semaphore.signal) { (movies, to) in
                if let posterPath = movies.compactMap({ $0.posterPath }).first {
                    client.requestPoster(path: posterPath, result: semaphore.signal)
                } else {
                    semaphore.signal(.failure(TestError.noPosters))
                }
            }
        }
        
        do {
            let result = try semaphore.wait()
            XCTAssertGreaterThan(result.count, 0)
        } catch let error {
            XCTAssertNil(error)
        }
    }
}
