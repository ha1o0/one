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
        case interfaceStyleChange = "interfaceStyleChange"
        case gotoVc = "gotoVc"
        case stopPosterLoop = "stopPosterLoop"
        case musicStatus = "musicStatus"
        case musicChange = "musicChange"
    }
    
    var hideAll: Bool = false
    
    func removeNotification(target: Any) {
        NotificationCenter.default.removeObserver(target)
    }
    
    func listenGotoVc(target: Any, selector: Selector) {
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name.init(State.gotoVc.rawValue), object: nil)
    }
    
    func gotoVc(_ vc: UIViewController, _ hideAll: Bool = false) {
        NotificationCenter.default.post(name: NSNotification.Name.init(State.gotoVc.rawValue), object: nil, userInfo: ["vc": vc, "hideAll": hideAll])
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
    
    func listenMusicChange(target: Any, selector: Selector) {
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name(State.musicChange.rawValue), object: nil)
    }
    
    func musicStatus(_ isPlaying: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(State.musicStatus.rawValue), object: nil, userInfo: ["isPlaying": isPlaying])
    }
    
    func musicChange() {
        NotificationCenter.default.post(name: NSNotification.Name(State.musicChange.rawValue), object: nil, userInfo: nil)
    }
    
    func listenInterfaceStyleChange(target: Any, selector: Selector) {
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name.init(State.interfaceStyleChange.rawValue), object: nil)
    }
    
    func interfaceStyleChange(style: UIUserInterfaceStyle) {
        NotificationCenter.default.post(name: NSNotification.Name(State.interfaceStyleChange.rawValue), object: nil, userInfo: ["style": style])
    }
    
    
}
