//
//  UIResponder+Target.swift
//  Lame
//
//  Created by John Scott on 11/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import UIKit

extension UIResponder {
    func target<Type>(conformingTo type: Type.Type) -> Type? {
        if let target = self as? Type {
            return target
        } else {
            return next?.target(conformingTo: type)
        }
    }
    
    func target<Type>(default value: Type?) -> Type? {
        if let value = value {
            return value
        } else {
            return next?.target(conformingTo: Type.self)
        }
    }
}
