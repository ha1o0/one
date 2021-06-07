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
        case stopPosterLoop = "stopPosterLoop"
        case musicStatus = "musicStatus"
    }
    
    func listenGotoVc(target: Any, selector: Selector) {
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name.init(State.gotoVc.rawValue), object: nil)
    }
    
    func gotoVc(_ vc: UIViewController) {
        NotificationCenter.default.post(name: NSNotification.Name.init(State.gotoVc.rawValue), object: nil, userInfo: ["vc": vc])
    }
    
    func listenStopPosterLoop(target: Any, selector: Selector) {
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name.init(State.stopPosterLoop.rawValue), object: nil)
    }
    
    func stopPosterLoop() {
        NotificationCenter.default.post(name: NSNotification.Name.init(State.stopPosterLoop.rawValue), object: nil)
    }
    
    func listenMusicStatus(target: Any, selector: Selector) {
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name(State.musicStatus.rawValue), object: nil)
    }
    
    func musicStatus(_ isPlaying: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(State.musicStatus.rawValue), object: nil, userInfo: ["isPlaying": isPlaying])
    }
    
    
}
