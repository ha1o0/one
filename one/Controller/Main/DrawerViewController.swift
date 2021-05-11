//
//  DrawerViewController.swift
//  one
//
//  Created by sidney on 5/10/21.
//

import UIKit

class DrawerViewController: BaseViewController, UIGestureRecognizerDelegate {

    var leftPanGesture: UIPanGestureRecognizer!
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
        contentView.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(leftPan))
        leftPanGesture.delegate = self
        contentView.addGestureRecognizer(leftPanGesture)
        
    }
    
    @objc func leftPan(sender: UIPanGestureRecognizer) {
        let distance = sender.translation(in: self.contentView)
        print("aaaa\(distance)")
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
