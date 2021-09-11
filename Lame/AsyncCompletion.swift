//
//  AsyncCompletion.swift
//  AsyncCompletion
//
//  Created by John Scott on 11/09/2021.
//  Copyright © 2021 John Scott. All rights reserved.
//

import Foundation


/**
 * Convenience method to connect function that take a Result based completion handler with Swift 5.5's async/await.
 *
 * func getFoo(..., completion: @escaping (Result<Foo,Error>)->Void)
 *
 * func foo(...) async throws -> Foo {
 *   return try await withResultHandler { resultHandler in
 *     getFoo(..., completion: resultHandler)
 *   }
 * }
 */
@available(iOS 15.0.0, *)
func withResultHandler<T, E: Error>(function: String = #function, _ body: (_ resultHandler: @escaping (Result<T, E>) -> ()) -> ()) async throws -> T {
    return try await withCheckedThrowingContinuation( { (continuation: CheckedContinuation<T, Error>) in
        body({ (result: Result<T, E>) in
            continuation.resume(with: result)
        })
    })
}

/**
 * Convenience method to connect function that take a Result based completion handler with Swift 5.5's async/await.
 *
 * func getFoo(..., completion: @escaping (Foo?, Error?)->Void)
 *
 * func foo(...) async throws -> Foo {
 *   return try await withCompletionHandler { completionHandler in
 *     getFoo(..., completion: completionHandler)
 *   }
 * }
 */
@available(iOS 15.0.0, *)
func withCompletionHandler<T, E: Error>(function: String = #function, _ body: (_ completionHandler: @escaping (T?, E?) -> ()) -> ()) async throws -> T {
    return try await withCheckedThrowingContinuation( { (continuation: CheckedContinuation<T, Error>) in
        body({ (result: T?, error: E?) in
            if let result = result {
                continuation.resume(returning: result)
            } else {
                continuation.resume(throwing: error!)
            }
        })
    })
}
