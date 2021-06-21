//
//  MusicPlayerWindow.swift
//  one
//
//  Created by sidney on 2021/6/21.
//

import Foundation
import UIKit

class MusicPlayerWindow: BaseWindow {
    
    var startHide: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initMusicWindow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initMusicWindow() {
        let musicPlayerNavigationViewController = BaseNavigationViewController(rootViewController: appDelegate.musicVc)
        self.rootViewController = musicPlayerNavigationViewController
        self.addGesture()
    }
    
    func addGesture() {
        let edgeSlideGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftPan))
        edgeSlideGesture.edges = .left
        self.addGestureRecognizer(edgeSlideGesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc func leftPan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        if sender.state == .ended || sender.state == .cancelled {
            if startHide {
                if location.x > 100 {
                    self.hide()
                } else {
                    self.show()
                }
            }
            startHide = false
            return
        }
        if sender.state == .began {
            startHide = true
        }
        if startHide {
            self.frame.origin.y = location.x * 1.5
        }
    }
    
    func show() {
        self.makeKeyAndVisible()
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseInOut) {
            self.frame.origin.y = 0
        }
        
    }
    
    func hide() {
        UIView.animate(withDuration: 0.4) {
            self.frame.origin.y = SCREEN_HEIGHT
        }
        self.resignKey()
    }
}
