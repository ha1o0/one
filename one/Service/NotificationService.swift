//
//  NotificationService.swift
//  one
//
//  Created by sidney on 5/19/21.
//

import Foundation
import UIKit

class NotificationService {
    static let shared = NotificationService()
    
    enum State: String {
        case gotoVc = "gotoVc"
    }
    
    func listenGotoVc(target: Any, selector: Selector) {
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name.init(State.gotoVc.rawValue), object: nil)
    }
    
    func gotoVc(_ vc: UIViewController) {
        NotificationCenter.default.post(name: NSNotification.Name.init(State.gotoVc.rawValue), object: nil, userInfo: ["vc": vc])
    }
}
