//
//  Target_scrolltabDemo.swift
//
//  Created by casa on 2020/2/21.
//  Copyright © 2020 casa. All rights reserved.
//

import UIKit

@objc class Target_scrolltab: NSObject {
    
    @objc func Action_Extension_ViewController(_ params:NSDictionary) -> UIViewController {
        if let callback = params["callback"] as? (String) -> Void {
            callback("success")
        }

        let viewController = DemoViewController()
        return viewController
    }
    
    @objc func Action_Category_ViewController(_ params:NSDictionary) -> UIViewController {
        
        if let block = params["callback"] {
            
            typealias CallbackType = @convention(block) (NSString) -> Void
            let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
            let callback = unsafeBitCast(blockPtr, to: CallbackType.self)
            
            callback("success")
        }
        
        let viewController = DemoViewController()
        return viewController
    }
    
    @objc func Action_viewController(_ params:[AnyHashable:Any]) -> UIViewController? {
//        guard let name = params["name"] as? String else { return nil }
//
//        if let callback = params["callback"] as? (String) -> Void {
//            callback("hello \(name) !")
//        }

        let viewController = DemoViewController()
        return viewController
    }
}
