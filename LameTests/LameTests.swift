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
    
    @available(iOS 15.0.0, *)
    func testTrendingRequest() async throws {
        
        let client = TheMovieDatabase()
        
        let trendingResults = try await withCheckedThrowingContinuation( { (continuation: CheckedContinuation<[TheMovieDatabase.TrendingResult], Error>) in
            client.requestTrending { result in
                continuation.resume(with: result)
            }
        })
        
        XCTAssertGreaterThan(trendingResults.count, 0)
    }
    
    /**
     testPosterRequestUsingExpecations and testPosterRequestUsingContinuations are the same test implemented in two
     different ways.
     */
    
    func testPosterRequestUsingExpecations() {
        let client = TheMovieDatabase()
        
        wait(timeout: 10) { expectation in
            client.requestTrending { result in
                switch result {
                case .success(let trendings):
                    if let posterPath = trendings.compactMap({ $0.posterPath }).first {
                        client.requestPoster(path: posterPath) { result in
                            switch result {
                            case .success(_): break
                            case .failure(_): expectation.isInverted = true
                            }
                            expectation.fulfill()
                        }
                    }
                case .failure(_): expectation.isInverted = true
                }
                expectation.fulfill()
            }
        }
    }
    
    @available(iOS 15.0.0, *)
    func testPosterRequestUsingContinuations() async throws {
        let client = TheMovieDatabase()

        let trendingResults = try await client.trending()
        
        if let posterPath = trendingResults.compactMap({ $0.posterPath }).first {
            _ = try await client.poster(path: posterPath)
        } else {
            XCTFail()
        }
    }
}
