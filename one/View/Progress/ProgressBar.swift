//
//  ProgressBar.swift
//  one
//
//  Created by sidney on 2021/6/22.
//

import Foundation
import UIKit

protocol ProgressBarDelegate: NSObject {
    func changeSliderValue(value: Float)
    func startChangeSliderValue(value: Float)
}

class ProgressBar: UIView {
    
    var currentCount: Float = 0
    var totalCount: Float = 0
    var showTimeLabel: Bool = true
    var width: CGFloat = 0
    var isDragging: Bool = false
    var changeValueCallback: ((_ value: Float) -> Void)?
    weak var delegate: ProgressBarDelegate?
    var progressBarView: CustomSlider = {
        let progressBar = CustomSlider()
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
            maker.center.equalToSuperview()
            maker.width.equalTo(self.width)
            maker.top.bottom.equalToSuperview()
        }
        self.progressBarView.setThumbImage(UIImage.getUIImageByName("sliderThumb1"), for: .normal)
        self.progressBarView.setThumbImage(UIImage.getUIImageByName("sliderThumb1"), for: .highlighted)
        self.progressBarView.minimumTrackTintColor = .white
        self.progressBarView.maximumTrackTintColor = .systemGray4
        self.progressBarView.value = self.currentCount
        self.progressBarView.maximumValue = self.totalCount
        // 如果为true，valueChanged事件也会在拖动时实时触发，false只会在拖动结束时触发
        self.progressBarView.isContinuous = false
        self.progressBarView.addTarget(self, action: #selector(changeSliderValue(slider:)), for: UIControl.Event.valueChanged)
        self.progressBarView.addTarget(self, action: #selector(startToChangeSliderValue(slider:)), for: UIControl.Event.touchDragInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSlider(sender:)))
        self.progressBarView.addGestureRecognizer(tapGesture)
        self.progressBarView.isUserInteractionEnabled = true
        self.updateView(currentCount: self.currentCount, totalCount: self.totalCount)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.progressBarView.snp.updateConstraints { (maker) in
            maker.width.equalTo(self.bounds.width * (self.showTimeLabel ? 0.7 : 1))
        }
    }
    
    @objc func execChangeValue(value: Float) {
        if let callback = self.changeValueCallback {
            callback(value)
        }
    }
    
    @objc func changeSliderValue(slider: UISlider) {
        self.isDragging = false
        self.updateView(currentCount: slider.value, totalCount: self.totalCount)
        self.delegate?.changeSliderValue(value: slider.value)
        self.execChangeValue(value: slider.value)
    }
    
    @objc func tapSlider(sender: UITapGestureRecognizer) {
        self.isDragging = false
        let tapPoint = sender.location(in: self.progressBarView)
        let value = CGFloat((self.progressBarView.maximumValue - self.progressBarView.minimumValue)) * tapPoint.x / self.progressBarView.frame.width
        self.updateView(currentCount: Float(value), totalCount: self.totalCount)
        self.delegate?.changeSliderValue(value: Float(value))
        self.execChangeValue(value: Float(value))
    }
    
    @objc func startToChangeSliderValue(slider: UISlider) {
        self.isDragging = true
        self.updateView(currentCount: slider.value, totalCount: self.totalCount, fromSliderDrag: true)
        self.delegate?.startChangeSliderValue(value: slider.value)
    }
    
    func updateView(currentCount: Float, totalCount: Float, fromSliderDrag: Bool = false) {
        if isDragging && !fromSliderDrag {
            return
        }
        self.currentCount = currentCount
        self.totalCount = totalCount
        self.progressBarView.value = currentCount
        if totalCount > 0 {
            self.progressBarView.maximumValue = totalCount
            self.totalTimeLabel.text = "\(TimeUtil.getTimeBySeconds(Int(totalCount)))"
        } else {
            self.totalTimeLabel.text = "\(TimeUtil.getTimeBySeconds(0))"
        }
        self.currentProgressLabel.text = "\(TimeUtil.getTimeBySeconds(Int(currentCount)))"
    }
}
