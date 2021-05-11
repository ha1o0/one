//
//  DrawerViewController.swift
//  one
//
//  Created by sidney on 5/10/21.
//

import UIKit

class DrawerViewController: BaseViewController, UIGestureRecognizerDelegate {

    var leftPanGesture: UIPanGestureRecognizer!
    var enableOpenLeftVc = true
    var startOpenLeftVc = false
    lazy var contentView: UIView = {
        let _contentView = UIView()
        return _contentView
    }()
    
    var tabbarVc: TabBarViewController? {
        didSet {
            if tabbarVc != nil {
                contentView.addSubview(tabbarVc!.view)
                tabbarVc!.view.frame = self.contentView.bounds
            }
        }
    }
    
    var leftVc: UIViewController? {
        didSet {
            if leftVc != nil {
                contentView.addSubview(leftVc!.view)
                var frame = self.contentView.bounds
                frame.origin.x = -frame.size.width
                leftVc!.view.frame = frame
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(leftPan))
        leftPanGesture.delegate = self
        contentView.addGestureRecognizer(leftPanGesture)
        
    }
    
    func setup() {
        
    }
    
    @objc func leftPan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: contentView)
        let distance = sender.translation(in: self.contentView)
        print("aaaa\(distance), bbb\(location)")
        if !enableOpenLeftVc {
            return
        }
        if sender.state == .ended {
            if startOpenLeftVc {
                UIView.animate(withDuration: 0.3) {
                    self.leftVc!.view.frame.origin.x = -SCREEN_WIDTH + (location.x > 50 ? 300 : 0)
                }
            }
            startOpenLeftVc = false
            return
        }
        if location.x < 25 && sender.state == .began {
            startOpenLeftVc = true
        }
        if startOpenLeftVc {
            leftVc!.view.frame.origin.x = -SCREEN_WIDTH + location.x
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchbegin")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchend")
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
//        print(event)
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print(touch)
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
