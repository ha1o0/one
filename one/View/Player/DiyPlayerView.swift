//
//  DiyPlayerView.swift
//  diyplayer
//
//  Created by sidney on 2018/8/26.
//  Copyright © 2018年 sidney. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SnapKit
import MediaPlayer
import Toast_Swift

enum PanType {
    case volume
    case progress
}

class DiyPlayerView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var fullBtn: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var cacheSlider: UISlider!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var topControlView: UIView!
    @IBOutlet weak var dateTimeDisplayLabel: UILabel!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var controlViewHeight: NSLayoutConstraint!
    @IBOutlet weak var centerProgressDisplayLabel: UILabel!
    @IBOutlet weak var bottomProgressView: UIProgressView!
    
    var loadingImageView: UIImageView!
    var playerItem: AVPlayerItem!
    var player: AVPlayer! = nil
    var playerLayer: AVPlayerLayer!
    var systemVolumeView = MPVolumeView()
    var videoUrl = ""
    var totalTimeSeconds = 0
    var totalTime = "00:00"
    var currentTime = "00:00"
    var sliderThumbFollowGesture = false
    var justDrag: Int = 0 //防止拖动播放瞬间滑块闪回
    var isFullScreen = false
    var originalFrame = CGRect.zero
    var hasSetControlView = false
    var currentPanType: PanType! = nil
    var currentVolume = 0.0
    var currentProgress = 0.0
    var showControlView = true
    var fadeControlViewLock = 0
    var autoFadeControlViewSecond = 5
    var isHideControlViewTimerRun = false
    var hideControlViewTimer: Timer!
    var dateTimeDisplayTimer: Timer!
    var clickDebounceTimer: Timer!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("frame")
        Bundle.main.loadNibNamed("DiyPlayerView", owner: self, options: nil)
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("coder")
    }

    func addGesture() {
        // 单击隐藏控制条手势
        let clickTap = UITapGestureRecognizer(target: self, action: #selector(clickTapPlayer(_:)))
        clickTap.numberOfTapsRequired = 1
        gestureView.addGestureRecognizer(clickTap)
        // 双击播放和暂停手势
        let doubleTap = UITapGestureRecognizer(target: self, action:#selector(doubleTapPlayer))
        doubleTap.numberOfTapsRequired = 2
        gestureView.addGestureRecognizer(doubleTap)
        // 滑动进度手势+-音量手势
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(changeVolumeProgress(_:)))
        gestureView.addGestureRecognizer(panGesture)
    }

    func initMPVolumeView() {
        systemVolumeView.frame.size = CGSize.init(width: 200, height: 1)
        systemVolumeView.center = self.playerView.center
        systemVolumeView.isHidden = true
        self.playerView.addSubview(systemVolumeView)
    }

    private func getSystemVolumeSlider() -> UISlider {
        var volumeViewSlider = UISlider()
        for subView in systemVolumeView.subviews {
            if type(of: subView).description() == "MPVolumeSlider" {
                volumeViewSlider = subView as! UISlider
                return volumeViewSlider
            }
        }
        return volumeViewSlider
    }

    private func getSystemVolumeValue() -> Float {
        return self.getSystemVolumeSlider().value
    }

    private func setSystemVolumeValue(_ value: Float) {
        self.getSystemVolumeSlider().value = value
    }

    func commonInit() {
        let loadingGif = UIImage.gifImageWithName("juhua")
        loadingImageView = UIImageView(image: loadingGif)
        self.playerView.addSubview(loadingImageView)
        loadingImageView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.playerView)
            maker.centerX.equalTo(self.playerView)
            maker.width.equalTo(33)
            maker.height.equalTo(33)
        }
        loadingImageView.isHidden = true
        initSlider()
        addGesture()
        initMPVolumeView()
        contentView.frame = self.bounds
        addSubview(contentView)
        originalFrame = self.frame
        startDateTimeTimer()
    }
    
    func initSlider() {
        progressSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        progressSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .highlighted)
        progressSlider.minimumValue = 0
        progressSlider.value = 0
        cacheSlider.isUserInteractionEnabled = false
        cacheSlider.setThumbImage(UIImage(named: "transparent"), for: .normal)
        cacheSlider.setThumbImage(UIImage(named: "transparent"), for: .highlighted)
        cacheSlider.minimumValue = 0
        cacheSlider.value = 0
        progressSlider.isContinuous = false
        progressSlider.addTarget(self, action: #selector(changeSliderValue(slider:)), for: UIControl.Event.valueChanged)
        progressSlider.addTarget(self, action: #selector(startToChangeSliderValue(slider:)), for: UIControl.Event.touchDragInside)
        bottomProgressView.progressTintColor = UIColor.main
        bottomProgressView.trackTintColor = UIColor.clear
        
    }
    
    func setControlView() {
        if hasSetControlView {
            controlView.layer.sublayers?.remove(at: 0)
            topControlView.layer.sublayers?.remove(at: 0)
        }
        let blackGradientColor = UIColor.black.withAlphaComponent(0.5).cgColor
        controlView.setGradientBackgroundColor(colors: [blackGradientColor, UIColor.clear.cgColor], locations: [0, 1], startPoint: CGPoint(x: 0.5, y: 1), endPoint: CGPoint(x: 0.5, y: 0))
        topControlView.setGradientBackgroundColor(colors: [UIColor.clear.cgColor, blackGradientColor], locations: [0, 1], startPoint: CGPoint(x: 0.5, y: 1), endPoint: CGPoint(x: 0.5, y: 0))
        hasSetControlView = true
    }
    
    override func layoutSubviews() {
        print("layout")
        super.layoutSubviews()
        if controlView != nil && topControlView != nil {
            setControlView()
        }
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            
            let status: AVPlayerItem.Status
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over the status
            switch status {
            case .readyToPlay:
                
                if (Int(playerItem.duration.timescale) == 0 || player == nil) {
                    return
                }
                totalTimeSeconds = Int(playerItem.duration.value) / Int(playerItem.duration.timescale)
                progressSlider.maximumValue = Float(totalTimeSeconds)
                cacheSlider.maximumValue = Float(totalTimeSeconds)
                totalTime = "\(TimeUtil.getTimeMinutesBySeconds(totalTimeSeconds)):\(TimeUtil.getTimeSecondBySeconds(totalTimeSeconds))"
                timeDisplay.text = "00:00/\(totalTime)"
                print("ready play")
                NotificationCenter.default.addObserver(self, selector: #selector(playToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)

                player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1/10.0, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil, using: { (time) in
                    if (self.player == nil) {
                        return
                    }
                    if let isPlaybackLikelyToKeepUp = self.player.currentItem?.isPlaybackLikelyToKeepUp {
                        //do what ever you want with isPlaybackLikelyToKeepUp value, for example, show or hide a activity indicator.
                        self.loadingImageView.isHidden = isPlaybackLikelyToKeepUp || !self.player.isPlaying
                    }
                    
                    if let bufferEmpty = self.player.currentItem?.isPlaybackBufferEmpty {
                        if (bufferEmpty && self.player.isPlaying) {
                            self.player.play()
                        }
                    }
                    
                    if (self.player.currentItem?.isPlaybackBufferFull) != nil {
                        self.loadingImageView.isHidden = true
                        if (self.player.isPlaying) {
                            self.player.play()
                        }
                    }
   
                    if (!self.sliderThumbFollowGesture) {
                        self.timeDisplay.text = "\(TimeUtil.getTimeMinutesBySeconds(Int(CMTimeGetSeconds(time)))):\(TimeUtil.getTimeSecondBySeconds(Int(CMTimeGetSeconds(time))))/\(self.totalTime)"
                        if (self.justDrag > 0) {
                            self.justDrag -= 1
                        } else {
                            self.progressSlider.value = Float(CMTimeGetSeconds(time))
                            self.bottomProgressView.progress = self.progressSlider.value / self.progressSlider.maximumValue
                        }
                    }
                })
                
                break
            // Player item is ready to play.
            case .failed:
                self.makeToast("播放失败")
                reset()
                break
            // Player item failed. See error.
            case .unknown:
                self.makeToast("播放失败")
                reset()
                break
                // Player item is not yet ready.
            @unknown default:
                break
            }
        }
        
        if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges) {
            if playerItem == nil || playerItem.loadedTimeRanges.count == 0 {
                return
            }
            let cacheSeconds = Int(playerItem.loadedTimeRanges[0].timeRangeValue.duration.value) / Int(playerItem.loadedTimeRanges[0].timeRangeValue.duration.timescale)
            if totalTimeSeconds > 0 && Float(cacheSeconds) > cacheSlider.value {
                cacheSlider.value = Float(cacheSeconds)
            }
        }
    }
    
    @IBAction func fullScreenPlayer(_ sender: UIButton) {
        controlViewHeight.constant = (hasSafeArea && !isFullScreen) ? 70 : 44
        if isFullScreen {
            exitFullScreen()
        } else {
            fullScreen()
        }
    }
    
    @objc func fullScreen() {
        isFullScreen = true
        appDelegate.hideStatusBar()
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        playerLayer.frame = self.bounds
        appDelegate.deviceOrientation = .landscapeRight
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        dateTimeDisplayLabel.isHidden = !isFullScreen
        bottomProgressView.alpha = 0
//        playerLayer.videoGravity = .resizeAspectFill
        
    }
    
    @objc func exitFullScreen() {
        isFullScreen = false
        appDelegate.showStatusBar()
        self.frame = originalFrame
        playerLayer.frame = self.bounds
        appDelegate.deviceOrientation = .portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        dateTimeDisplayLabel.isHidden = !isFullScreen
        bottomProgressView.alpha = showControlView ? 0 : 1
    }
    
    @IBAction func playOrPause(_ sender: UIButton) {
        if player == nil {
            return
        }
        player.isPlaying ? player.pause() : player.play()
        sender.setImage(player.isPlaying ? UIImage(named: "pause") : UIImage(named: "play"), for: .normal)
        loadingImageView.isHidden = !player.isPlaying
        print("isplaying", player.isPlaying)
    }

    // 开始拖动
    @objc func startToChangeSliderValue(slider: UISlider) {
        print("start slider.value = %d",slider.value)
        self.timeDisplay.text = "\(TimeUtil.getTimeMinutesBySeconds(Int(slider.value))):\(TimeUtil.getTimeSecondBySeconds(Int(slider.value)))/\(self.totalTime)"
        self.centerProgressDisplayLabel.isHidden = false
        self.centerProgressDisplayLabel.text = self.timeDisplay.text
        self.bottomProgressView.progress = slider.value / self.progressSlider.maximumValue
        sliderThumbFollowGesture = true
        self.stopHideControlViewTimer()
    }
    
    // 拖动结束
    @objc func changeSliderValue(slider: UISlider) {
        print("slider.value = %d",slider.value)
        justDrag = 2
        player.pause()
        player.seek(to: CMTimeMakeWithSeconds(Float64(slider.value), preferredTimescale: 64))
        player.play()
        loadingImageView.isHidden = !player.isPlaying
        self.playBtn.setImage(UIImage(named: "pause"), for: .normal)
        self.centerProgressDisplayLabel.isHidden = true
        sliderThumbFollowGesture = false
        if showControlView {
            self.startHideControlViewTimer()
        }
    }
    
    @objc func clickTapPlayer(_ sender: UITapGestureRecognizer) {
        clickDebounceTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(singleClick), userInfo: nil, repeats: false)
    }
    
    @objc func singleClick() {
        fadeControlView()
    }
    
    @objc func doubleTapPlayer() {
        print("double tap")
        if clickDebounceTimer != nil {
            clickDebounceTimer.invalidate()
            clickDebounceTimer = nil
        }
        playOrPause(self.playBtn)
    }

    @objc func changeVolumeProgress(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: gestureView)
        let absx = abs(Int32(translation.x))
        let absy = abs(Int32(translation.y))
        print("\(translation)")
        if (absx > 20 || absy > 20) && currentPanType == nil {
            currentPanType = absx > absy ? .progress : .volume
        }
        if sender.state == .began {
            currentVolume = Double(self.getSystemVolumeValue())
            currentProgress = Double(self.progressSlider.value)
        }
        if currentPanType == .volume {
            let step = 0.006 // y pt步进音量（0-1）
            self.setSystemVolumeValue(Float(currentVolume - (step * Double(translation.y))))
        }
        if currentPanType == .progress {
            let step: CGFloat =  isFullScreen ? (90 / 600) : (90 / 300) // x pt步进s
            progressSlider.value = Float(currentProgress + Double(step * translation.x))
            startToChangeSliderValue(slider: progressSlider)
        }
        if sender.state == .ended {
            if currentPanType == .progress {
                changeSliderValue(slider: progressSlider)
            }
            currentPanType = nil
        }
        
    }
    
    @objc func playToEnd() {
        if player == nil {
            return
        }
        playBtn.setImage(UIImage(named: "play"), for: .normal)
        playerItem.seek(to: CMTime.zero) { (bool) in }
        player.pause()
        bottomProgressView.progress = 0
    }
    
    func closePlayer(){
        if (player != nil) {
            print("关闭播放器")
            player.pause()
            removePlayerObserver(playerItem: playerItem)
            player = nil
            stopHideControlViewTimer()
        }
    }
    
    func playUrl(url: String) {
        if url == videoUrl {
            print("地址未变化")
            return
        }
        guard let urlURL = URL(string: url) else {
            print(url)
            fatalError("播放地址错误")
        }
        if player != nil {
            print("移除")
            playToEnd()
            closePlayer()
            playerView.layer.sublayers?.remove(at: 0)
            stopHideControlViewTimer()
        }
        
        let asset = AVAsset(url: urlURL)
        playerItem = AVPlayerItem(asset: asset)
        addPlayerObserver(playerItem: playerItem)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.contentsScale = UIScreen.main.scale
        playerLayer.frame = self.bounds
        playerView.layer.insertSublayer(playerLayer, at: 0)
        playOrPause(self.playBtn)
        videoUrl = url
        startHideControlViewTimer()
    }
    
    @objc func reset() {
        currentTime = "00:00"
        totalTime = "00:00"
        timeDisplay.text = "\(currentTime)/\(totalTime)"
        progressSlider.value = .zero
        cacheSlider.value = .zero
        playToEnd()
    }
    
    @IBAction func pop(_ sender: UIButton) {
        controlViewHeight.constant = 44
        if isFullScreen {
            exitFullScreen()
            return
        }
        self.parentViewController?.navigationController?.popViewController(animated: true)
    }
    
    func addPlayerObserver(playerItem:AVPlayerItem) {
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
    }
    
    func removePlayerObserver(playerItem:AVPlayerItem) {
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
        playerItem.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        playerItem.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        playerItem.removeObserver(self, forKeyPath: "playbackBufferFull")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

// 控制条显示
extension DiyPlayerView {
    @objc func fadeControlView() {
        if fadeControlViewLock == 1 {
            return
        }
        
        UIView.animate(withDuration: 0.5) {
            let alpha = self.showControlView ? CGFloat.zero : 1.0
            self.controlView.alpha = alpha
            self.topControlView.alpha = alpha
            self.fadeControlViewLock = 1
            self.bottomProgressView.alpha = (self.isFullScreen || !self.showControlView) ? CGFloat.zero : 1
        } completion: { (result) in
            self.showControlView = !self.showControlView
            self.fadeControlViewLock = 0
            if self.showControlView {
                self.stopHideControlViewTimer()
                self.startHideControlViewTimer()
            }
            
        }

    }
    
    @objc func hideControlView() {
        UIView.animate(withDuration: 0.5) {
            let alpha = CGFloat.zero
            self.controlView.alpha = alpha
            self.topControlView.alpha = alpha
            self.bottomProgressView.alpha = self.isFullScreen ? 0 : 1
        } completion: { (result) in
            self.showControlView = !self.showControlView
            self.fadeControlViewLock = 0
            self.isHideControlViewTimerRun = false
        }
    }
    
    func startHideControlViewTimer() {
        if !isHideControlViewTimerRun {
            isHideControlViewTimerRun = true
            hideControlViewTimer = Timer.scheduledTimer(timeInterval: TimeInterval(autoFadeControlViewSecond), target: self, selector: #selector(hideControlView), userInfo: nil, repeats: false)
        }
    }
    
    func stopHideControlViewTimer() {
        if !isHideControlViewTimerRun {
            return
        }
        hideControlViewTimer.invalidate()
        hideControlViewTimer = nil
        isHideControlViewTimerRun = false
    }
}

// 时间显示
extension DiyPlayerView {
    
    @objc func updateDateTime() {
        dateTimeDisplayLabel.text = TimeUtil.getCurrentTime()
    }
    
    func startDateTimeTimer() {
        dateTimeDisplayTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateDateTime), userInfo: nil, repeats: true)
    }
    
    func endDateTimeTimer() {
        dateTimeDisplayTimer.invalidate()
        dateTimeDisplayTimer = nil
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}
