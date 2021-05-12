//
//  LeftDrawerViewController.swift
//  one
//
//  Created by sidney on 5/11/21.
//

import UIKit

class LeftDrawerViewController: UIViewController {
    
    let visibleViewWidth: CGFloat = CGFloat(SCREEN_WIDTH * 0.82)
    
    lazy var contentView: UIView = {
        let _contentView = UIView()
        _contentView.backgroundColor = .lightText
        _contentView.frame = CGRect(x: SCREEN_WIDTH - visibleViewWidth, y: 0, width: visibleViewWidth, height: SCREEN_HEIGHT)
        return _contentView
    }()
    
    var topBarView: UIView = {
        let _topBarView = UIView()
        let avatarView = UIImageView()
        let avatarUrl = "http://b-ssl.duitang.com/uploads/item/201809/24/20180924092018_zjgut.jpg"
        avatarView.loadFrom(link: avatarUrl, isCircle: true)
        _topBarView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(0)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(33)
            maker.height.equalTo(33)
        }
        return _topBarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("leftdrawvc didload")
    }
    
    func setup() {
        self.view.addSubview(contentView)
//        self.contentView.addSubview(topBarView)
//        topBarView.snp.makeConstraints { (maker) in
//            maker.top.equalToSuperview().offset(STATUS_BAR_HEIGHT)
//            maker.leading.equalToSuperview().offset(16)
//            maker.trailing.equalToSuperview().offset(-16)
//            maker.height.equalTo(50)
//        }
    }
}
