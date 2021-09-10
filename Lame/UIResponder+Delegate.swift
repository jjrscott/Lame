//
//  UIResponder+Delegate.swift
//  Lame
//
//  Created by John Scott on 7/29/21.
//  Copyright © 2021 John Scott. All rights reserved.
//

import UIKit

protocol UIResponderDelegate : UIResponder {
    
    associatedtype Delegate
    
    var delegate: Delegate? { get set }
    
    var target: Delegate? { get }
}

extension UIResponderDelegate {
        
    var target: Delegate? { return delegate ?? next(as: Delegate.self) }
}

extension UIResponder {
    func next<Type>(as type: Type.Type) -> Type? {
        if let value = self as? Type {
            return value
        } else {
            return next?.next(as: type)
        }
    }
}
