//
//  UIResponder+Next.swift
//  Lame
//
//  Created by John Scott on 11/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import UIKit

extension UIResponder {
    func next<Type>(as type: Type.Type) -> Type? {
        if let target = self as? Type {
            return target
        } else {
            return next?.next(as: type)
        }
    }
    
    func next<Type>(default value: Type?) -> Type? {
        if let value = value {
            return value
        } else {
            return next?.next(as: Type.self)
        }
    }
}
