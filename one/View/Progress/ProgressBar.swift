//
//  ProgressBar.swift
//  one
//
//  Created by sidney on 2021/6/22.
//

import Foundation
import UIKit

class ProgressBar: UIView {
    
    var currentCount: Float = 0
    var totalCount: Float = 0
    var showTimeLabel: Bool = true
    var width: CGFloat = 0
    var progressBarView: UISlider = {
        let progressBar = UISlider()
        return progressBar
    }()
    
    var currentProgressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var totalTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    convenience init(width: CGFloat, currentCount: Float, totalCount: Float, showTimeLabel: Bool = true) {
        self.init()
        self.currentCount = currentCount
        self.totalCount = totalCount
        self.showTimeLabel = showTimeLabel
        self.width = width
        self.commonInit()
    }
    
    func commonInit() {
        if self.showTimeLabel {
            self.addSubview(currentProgressLabel)
            currentProgressLabel.snp.makeConstraints { (maker) in
                maker.centerY.equalToSuperview()
                maker.leading.equalToSuperview()
            }
            self.addSubview(totalTimeLabel)
            totalTimeLabel.snp.makeConstraints { (maker) in
                maker.centerY.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
        }
        self.addSubview(progressBarView)
        progressBarView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(self.width)
            maker.top.bottom.equalToSuperview()
        }
        self.progressBarView.setThumbImage(UIImage.getUIImageByName("sliderThumb1"), for: .normal)
        self.progressBarView.setThumbImage(UIImage.getUIImageByName("sliderThumb1"), for: .highlighted)
        self.progressBarView.minimumTrackTintColor = .white
        self.progressBarView.maximumTrackTintColor = .systemGray4
        self.progressBarView.value = self.currentCount
        self.progressBarView.maximumValue = self.totalCount
        self.updateView(currentCount: self.currentCount, totalCount: self.totalCount)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.progressBarView.snp.updateConstraints { (maker) in
            maker.width.equalTo(self.bounds.width * 0.7)
        }
    }
    
    func updateView(currentCount: Float, totalCount: Float) {
        self.currentCount = currentCount
        self.totalCount = totalCount
        self.progressBarView.value = currentCount
        self.currentProgressLabel.text = "\(TimeUtil.getTimeBySeconds(Int(currentCount)))"
        self.totalTimeLabel.text = "\(TimeUtil.getTimeBySeconds(Int(totalCount)))"
    }
}
