//
//  UIViewController+Segue.swift
//  Lame
//
//  Created by John Scott on 12/04/2019.
//  Copyright © 2019 John Scott. All rights reserved.
//

import UIKit
import ObjectiveC

extension UIViewController {
    
    func performSegue<T: UIViewController>(withIdentifier identifier: String, prepare: ((T)->Void)? = nil) {
        guard let method = class_getInstanceMethod(UIViewController.self, #selector(prepare(for:sender:))) else { fatalError() }
        let originalImplemention = method_getImplementation(method)
        
        let temporaryBlock : @convention(block) (UIViewController, UIStoryboardSegue) -> Void = { (self : UIViewController, segue: UIStoryboardSegue) -> Void in
            if let viewController = segue.destination as? T {
                prepare?(viewController)
            }
        }
        
        let temporaryImplemention = imp_implementationWithBlock(unsafeBitCast(temporaryBlock, to: AnyObject.self))
        
        method_setImplementation(method, temporaryImplemention);
        
        performSegue(withIdentifier: identifier, sender: nil)
        
        method_setImplementation(method, originalImplemention);
        
        imp_removeBlock(temporaryImplemention);
    }
}
