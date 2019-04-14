//
//  Result+Pipe.swift
//  Lame
//
//  Created by John Scott on 14/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import Foundation

extension Result {
    func pipe<NewSuccess>(to: @escaping (Result<NewSuccess, Failure>)->Void, transform: (Success, (Result<NewSuccess, Failure>)->Void) -> Void) {
        switch self {
        case .success(let value):
            transform(value, to)
        case .failure(let error):
            to(.failure(error))
        }
    }
}
