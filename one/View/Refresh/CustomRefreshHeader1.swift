//
//  CustomRefreshHeader1.swift
//  one
//
//  Created by sidney on 2021/6/6.
//

import Foundation
import MJRefresh

class CustomRefreshHeader1: MJRefreshStateHeader {
    
    var imageView: UIImageView = {
        let _imageView = UIImageView(image: UIImage.gifImageWithName("refresh"))
        return _imageView
    }()
    
    override var state: MJRefreshState {
        set {
            super.state = newValue
            self.imageView.isHidden = newValue == .idle
        }
        get {
            return super.state
        }
    }
    
    override var pullingPercent: CGFloat {
        set {
            super.pullingPercent = newValue
            self.imageView.isHidden = newValue <= 0.01
        }
        
        get {
            return super.pullingPercent
        }
    }
    
    override func prepare() {
        super.prepare()
        self.stateLabel?.isHidden = true
        self.lastUpdatedTimeLabel?.isHidden = true
        self.addSubview(imageView)
        imageView.snp.makeConstraints({ (maker) in
            maker.center.equalToSuperview()
            maker.width.equalTo(80)
            maker.height.equalTo(80)
        })
    }
}

