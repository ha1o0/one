//
//  DrawerViewController.swift
//  one
//
//  Created by sidney on 5/10/21.
//

import UIKit

// root vc (带tabbar vc和左侧抽屉 vc)
class DrawerViewController: BaseViewController, UIGestureRecognizerDelegate {

    var leftPanGesture: UIScreenEdgePanGestureRecognizer!
    let shadowAlpha: Double = 0.6
    let leftVcVisibleViewWidth: Double = Double(SCREEN_WIDTH * leftVcleftVcVisibleViewWidthPercent)
    var startOpenLeftVc = false
    var enableOpenLeftVc: Bool = false {
        didSet {
            if enableOpenLeftVc {
                self.enableContentViewLeftPan()
            } else {
                self.disableContentViewLeftPan()
            }
        }
    }

    var tabbarVc: CustomTabBarViewController? {
        didSet {
            if tabbarVc != nil {
                contentView.addSubview(tabbarVc!.view)
                // 自动布局防止视频全屏问题
                tabbarVc!.view.snp.makeConstraints { (maker) in
                    maker.top.bottom.leading.trailing.equalToSuperview()
                }
                print("add tabbarVc")
                self.contentView.addSubview(shadowView)
            }
        }
    }
    
    var leftVc: LeftDrawerViewController? {
        didSet {
            if leftVc != nil {
                contentView.addSubview(leftVc!.view)
                // 自动布局防止视频全屏问题
                leftVc!.view.snp.makeConstraints { (maker) in
                    maker.trailing.equalTo(contentView.snp.leading).offset(0)
                    maker.top.bottom.equalToSuperview()
                    maker.width.equalTo(contentView.bounds.width)
                }
//                var frame = self.contentView.bounds
//                frame.origin.x = -frame.size.width
//                leftVc!.view.frame = frame
                print("add leftVc\(leftVc!.contentView)")
            }
        }
    }
    
    lazy var contentView: UIView = {
        let _contentView = UIView()
        _contentView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return _contentView
    }()
    
    lazy var shadowView: UIView = {
        let _shadowView = UIView()
        _shadowView.backgroundColor = .black
        _shadowView.alpha = 0
        _shadowView.isHidden = true
        _shadowView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeLeftVcByTap))
        _shadowView.addGestureRecognizer(tapGesture)
        _shadowView.isUserInteractionEnabled = true
        return _shadowView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentView)
        // 修复视频全屏时，tabbar半屏问题
        contentView.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        print("didload")
        leftPanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftPan))
        leftPanGesture.edges = .left
    }
    
    @objc func leftPan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: contentView)
        if !enableOpenLeftVc {
            return
        }
        if sender.state == .ended || sender.state == .cancelled {
            if startOpenLeftVc {
                if location.x > 50 {
                    self.openLeftVc()
                } else {
                    self.closeLeftVc()
                }
            }
            startOpenLeftVc = false
            return
        }
        if sender.state == .began {
            startOpenLeftVc = true
        }
        if startOpenLeftVc {
            self.shadowView.isHidden = false
            self.shadowView.alpha = min(CGFloat(shadowAlpha / leftVcVisibleViewWidth) * location.x, CGFloat(self.shadowAlpha))
            leftVc!.view.frame.origin.x = -SCREEN_WIDTH + min(location.x, CGFloat(self.leftVcVisibleViewWidth))
        }
    }
    
    @objc func openLeftVc() {
        self.shadowView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.shadowView.alpha = CGFloat(self.shadowAlpha)
            self.leftVc!.view.frame.origin.x = -SCREEN_WIDTH + CGFloat(self.leftVcVisibleViewWidth)
        } completion: { (result) in
            self.disableContentViewLeftPan()
            self.leftVc?.addGesture()
            self.leftVc?.drawVc = self
        }
        
    }
    
    @objc func closeLeftVcByTap() {
        self.closeLeftVc()
    }
    
    @objc func closeLeftVc(callback: @escaping () -> Void = { return }) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.shadowView.alpha = 0
            self.leftVc!.view.frame.origin.x = -SCREEN_WIDTH
        } completion: { (result) in
            self.shadowView.isHidden = true
            if self.enableOpenLeftVc {
                self.enableContentViewLeftPan()
            }
            self.leftVc?.removeGesture()
            callback()
        }
    }
    
    @objc func closeLeftVcWithoutAnimation() {
        self.shadowView.alpha = 0
        self.leftVc!.view.frame.origin.x = -SCREEN_WIDTH
        self.shadowView.isHidden = true
        if self.enableOpenLeftVc {
            self.enableContentViewLeftPan()
        }
        self.leftVc?.removeGesture()
    }
    
    func enableContentViewLeftPan() {
        self.contentView.addGestureRecognizer(leftPanGesture)
    }
    
    func disableContentViewLeftPan() {
        self.contentView.removeGestureRecognizer(leftPanGesture)
    }
}
