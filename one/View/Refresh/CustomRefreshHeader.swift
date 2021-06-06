//
//  CustomRefreshHeader.swift
//  one
//
//  Created by sidney on 2021/6/5.
//

import Foundation
import UIKit
import MJRefresh

class CustomRefreshHeader: MJRefreshStateHeader {
    lazy var stateGifImageView: UIImageView = {
        let _stateGifImageView = UIImageView()
        return _stateGifImageView
    }()
    
    var stateImages: [MJRefreshState: [UIImage]] = [:]
    var gifDuration = 0.15
    var oldState: MJRefreshState?
    override var state: MJRefreshState {
        set {
            self.oldState = state
            super.state = newValue
            self.setState(state: newValue)
        }
        get {
            return super.state
        }
    }
    
    
    func setImages(images: [UIImage], state: MJRefreshState) {
        self.stateImages[state] = images
        let image: UIImage = images[0]
        let imageHeight = image.size.height
        if imageHeight > self.mj_h {
            self.mj_h = imageHeight
        }
    }
    
    override func prepare() {
        super.prepare()
        self.labelLeftInset = 20
        let idleImages = self.getRefreshingImageArrayWithStartIndex(startIndex: 1, endIndex: 8)
        let refreshingImages = self.getRefreshingImageArrayWithStartIndex(startIndex: 9, endIndex: 10)
        self.setImages(images: idleImages, state: .idle)
        self.setImages(images: refreshingImages, state: .pulling)
        self.setImages(images: refreshingImages, state: .refreshing)
    }
    
    func setPullingPercent(pullingPercent: CGFloat) {
        guard let images = self.stateImages[.idle] else { return }
        if self.state != .idle || images.count == 0 {
            return
        }
        self.stateGifImageView.stopAnimating()
        var index = Int(CGFloat(images.count) * pullingPercent)
        if index >= images.count {
            index = images.count - 1
        }
        self.stateGifImageView.image = images[index]
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        if (self.stateGifImageView.constraints.count != 0) {
            return
        }
        self.stateLabel?.isHidden = true
        self.lastUpdatedTimeLabel?.isHidden = true
        self.stateGifImageView.frame = self.bounds
        self.stateGifImageView.contentMode = .center
    }
    
    func setState(state: MJRefreshState) {
        if state == .pulling || state == .refreshing {
            if let images = self.stateImages[state] {
                self.startGifViewAniamtionWithImages(images: images)
            } else if state == .idle {
                if oldState == .refreshing && state == .idle {
                    let endImages = self.getRefreshingImageArrayWithStartIndex(startIndex: 13, endIndex: 17)
                    self.startGifViewAniamtionWithImages(images: endImages)
                } else {
                    self.stateGifImageView.stopAnimating()
                }
            }
        }
    }
    
    func startGifViewAniamtionWithImages(images: [UIImage]) {
        if images.count == 0 {
            return
        }
        self.stateGifImageView.stopAnimating()
        if images.count == 1 {
            self.stateGifImageView.image = images[0]
        }
        self.stateGifImageView.animationImages = images
        self.stateGifImageView.animationDuration = Double(images.count) * self.gifDuration
        self.stateGifImageView.startAnimating()
    }
    
    func getRefreshingImageArrayWithStartIndex(startIndex: Int, endIndex: Int) -> [UIImage] {
        var result: [UIImage] = []
        for i in startIndex..<endIndex + 1 {
            let image = CacheManager.shared.refreshHeaderImages[i]
            result.append(image)
        }

        return result
    }
}
