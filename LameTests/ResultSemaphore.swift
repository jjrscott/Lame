//
//  ResultSemaphore.swift
//  Lame
//
//  Created by John Scott on 14/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import Foundation

class ResultSemaphore<Success, Failure> where Failure : Error {
    let semaphore = DispatchSemaphore(value: 0)
    
    var _result: Result<Success, Failure>!
    
    func signal(_ result: Result<Success, Failure>) {
        _result = result
        semaphore.signal()
    }
    
    func wait() throws -> Success {
        semaphore.wait()
        return try _result.get()
    }
}
