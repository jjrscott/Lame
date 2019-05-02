//
//  UIResponder+Next.swift
//  Lame
//
//  Created by John Scott on 11/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import UIKit

extension UIResponder {
    func next<Type>(as type: Type.Type, default value: Any? = nil) -> Type? {
        if let value = value as? Type {
            return value
        } else {
            return next(as: type)
        }
    }
    
    func next<Type>(as type: Type.Type) -> Type? {
        if let value = self as? Type {
            return value
        } else {
            return next?.next(as: type)
        }
    }
    
    func next<Type>(default value: Type?) -> Type? {
        return next(as: Type.self, default: value)
    }
    
    var chain: [UIResponder] {
        var chain: [UIResponder] = [self]
        var responder: UIResponder = self
        
        while let next = responder.next {
            chain.append(next)
            responder = next
        }
        
        return chain
    }
}
