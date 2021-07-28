//
//  DplayerView.swift
//  Dplayer
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

public enum PanType {
    case volume
    case progress
}

@objc public protocol DplayerDelegate: AnyObject {
    @objc optional func beforeFullScreen()
    @objc optional func fullScreen()
    @objc optional func beforeExitFullScreen()
    @objc optional func exitFullScreen()
    @objc optional func pip()
    @objc optional func playing(progress: Float, url: String)
    @objc optional func readyToPlay(totalTimeSeconds: Float)
}

public class DplayerView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var fullBtn: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var cacheSlider: UISlider!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var bottomControlContent1View: UIView!
    @IBOutlet weak var topControlView: UIView!
    @IBOutlet weak var topControlContent1View: UIView!
    @IBOutlet weak var dateTimeDisplayLabel: UILabel!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var controlViewHeight: NSLayoutConstraint!
    @IBOutlet weak var centerProgressDisplayLabel: UILabel!
    @IBOutlet weak var bottomProgressView: UIProgressView!
    @IBOutlet weak var rateTipView: UIView!
    @IBOutlet weak var rateTipLabel: UILabel!
    @IBOutlet weak var pipBtn: UIButton!
    
    public var playerItem: AVPlayerItem!
    public var player: AVPlayer! = nil
    public var playerLayer: AVPlayerLayer!
    public var danmuLayer: CALayer?
    public var currentProgress = 0.0
    public var playerRate: Float = 1.0
    public var longPressPlayRate: Float = 2.0
    public var danmuConfig: DanmuConfig = DanmuConfig()
    public var danmus: [Danmu] = []
    var danmuDict: [Float: [Danmu]] = [:]
    var danmuChannelDict: [Int: CGFloat] = [:]
    var danmuDictHandled: [Float: [Int: Danmu?]] = [:]
    var latestDanmuTimes: CapacityArray<Float> = CapacityArray<Float>(capacity: 5)
    var isSeekDanmu = false
    var loadingImageView: UIImageView!
    var systemVolumeView = MPVolumeView()
    var videoUrl = ""
    var isFullScreen = false
    var originalFrame = CGRect.zero
    var hasSetControlView = false
    var currentPanType: PanType! = nil
    var currentVolume = 0.0
    var showControlView = true
    var fadeControlViewLock = 0
    var autoFadeControlViewSecond = 5
    var currentPlayerRate: Float = 1.0
    var isHideControlViewTimerRun = false
    var hideControlViewTimer: Timer!
    var dateTimeDisplayTimer: Timer!
    var clickDebounceTimer: Timer!
    var danmuListenTimer: Timer!
    public var totalTimeSeconds = 0
    var totalTime = "00:00"
    var currentTime = "00:00"
    var sliderThumbFollowGesture = false
    var justDrag: Int = 0 //防止拖动播放瞬间滑块闪回
    public var bottomProgressBarViewColor: UIColor = .clear {
        didSet {
            self.bottomProgressView.progressTintColor = bottomProgressBarViewColor
        }
    }
    
    public weak var delegate: DplayerDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func nibInit() {
        let viewFromXib = getBundle().loadNibNamed("DplayerView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        self.commonInit()
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
        // 长按倍速播放手势
        let longTap = UILongPressGestureRecognizer(target: self, action:#selector(longPressPlayer(recognizer:)))
        gestureView.addGestureRecognizer(longTap)
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

    public func getPipVc() -> AVPictureInPictureController? {
        if !AVPictureInPictureController.isPictureInPictureSupported() {
            return nil
        }
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback)
            try session.setActive(true, options: [])
        } catch {
            print("AVAudioSession error")
            return nil
        }
        return AVPictureInPictureController(playerLayer: self.playerLayer)
    }
    
    public func startPip(_ pipVc: AVPictureInPictureController?) {
        guard let pipVc = pipVc else { return }
        let time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time) {
            if pipVc.isPictureInPictureActive == true {
                pipVc.stopPictureInPicture()
            } else {
                pipVc.startPictureInPicture()
            }
        }
    }
    
    public func commonInit() {
        self.currentPlayerRate = self.playerRate
        self.rateTipView.layer.cornerRadius = 2
        self.rateTipLabel.text = "\(self.longPressPlayRate)x倍速播放中"
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
        print(videoUrl)
        danmuListenTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(checkDanmuLayer), userInfo: nil, repeats: true)
    }
    
    func initSlider() {
        progressSlider.setThumbImage(UIImage.getUIImageByName("sliderThumb"), for: .normal)
        progressSlider.setThumbImage(UIImage.getUIImageByName("sliderThumb"), for: .highlighted)
        progressSlider.minimumValue = 0
        progressSlider.value = 0
        cacheSlider.isUserInteractionEnabled = false
        cacheSlider.setThumbImage(UIImage.getUIImageByName("transparent"), for: .normal)
        cacheSlider.setThumbImage(UIImage.getUIImageByName("transparent"), for: .highlighted)
        cacheSlider.minimumValue = 0
        cacheSlider.value = 0
        progressSlider.isContinuous = false
        progressSlider.addTarget(self, action: #selector(changeSliderValue(slider:)), for: UIControl.Event.valueChanged)
        progressSlider.addTarget(self, action: #selector(startToChangeSliderValue(slider:)), for: UIControl.Event.touchDragInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSliderValue(sender:)))
        progressSlider.addGestureRecognizer(tapGesture)
        self.bottomProgressBarViewColor = .clear
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
    
    public override func layoutSubviews() {
//        print("layout")
        super.layoutSubviews()
        if controlView != nil && topControlView != nil {
            setControlView()
        }
    }

    public override func observeValue(forKeyPath keyPath: String?,
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
                if let delegate = self.delegate, let readyToPlay = delegate.readyToPlay {
                    readyToPlay(Float(totalTimeSeconds))
                }
                self.prepareDanmu()
                print("ready play")
                NotificationCenter.default.addObserver(self, selector: #selector(playToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)

                player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1 / 10.0, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil, using: { (time) in
                    if (self.player == nil) {
                        return
                    }
                    if let isPlaybackLikelyToKeepUp = self.player.currentItem?.isPlaybackLikelyToKeepUp {
                        self.loadingImageView.isHidden = isPlaybackLikelyToKeepUp || !self.player.isPlaying
                    }
                    
                    if let bufferEmpty = self.player.currentItem?.isPlaybackBufferEmpty {
                        if (bufferEmpty && self.player.isPlaying) {
                            self.customPlay()
                        }
                    }
                    
                    if (self.player.currentItem?.isPlaybackBufferFull) != nil {
                        self.loadingImageView.isHidden = true
                        if (self.player.isPlaying) {
                            self.customPlay()
                        }
                    }
   
                    if (!self.sliderThumbFollowGesture) {
                        self.timeDisplay.text = "\(TimeUtil.getTimeMinutesBySeconds(Int(CMTimeGetSeconds(time)))):\(TimeUtil.getTimeSecondBySeconds(Int(CMTimeGetSeconds(time))))/\(self.totalTime)"
                        if (self.justDrag > 0) {
                            self.justDrag -= 1
                        } else {
                            self.progressSlider.value = Float(CMTimeGetSeconds(time))
                            self.playingDanmu(currentTime: self.progressSlider.value)
                            self.bottomProgressView.progress = self.progressSlider.value / self.progressSlider.maximumValue
                            if let playing = self.delegate?.playing {
                                playing(self.progressSlider.value, self.videoUrl)
                            }
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
    
    @objc public func fullScreen() {
        self.resetControlViewTimer()
        if let delegate = delegate, let beforeFullScreenFunc = delegate.beforeFullScreen {
            beforeFullScreenFunc()
        }
        isFullScreen = true
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        playerLayer.frame = self.bounds
        dateTimeDisplayLabel.isHidden = !isFullScreen
        bottomProgressView.alpha = 0
        self.resetDanmuLayer()
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        if let delegate = delegate, let fullScreenFunc = delegate.fullScreen {
            fullScreenFunc()
        }
    }
    
    @objc public func exitFullScreen() {
        self.resetControlViewTimer()
        if let delegate = delegate, let beforeExitFullScreenFunc = delegate.beforeExitFullScreen {
            beforeExitFullScreenFunc()
        }
        isFullScreen = false
        self.frame = originalFrame
        playerLayer.frame = self.bounds
        dateTimeDisplayLabel.isHidden = !isFullScreen
        bottomProgressView.alpha = showControlView ? 0 : 1
        self.resetDanmuLayer()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        if let delegate = delegate, let exitFullScreenFunc = delegate.exitFullScreen {
            exitFullScreenFunc()
        }
    }
    
    @IBAction func pip(_ sender: UIButton) {
        if let delegate = delegate, let pip = delegate.pip {
            pip()
        }
    }
    
    @IBAction func playOrPause(_ sender: UIButton) {
        self.resetControlViewTimer()
        if player == nil {
            return
        }
        if player.isPlaying {
            player.pause()
        } else {
            self.customPlay()
        }
        sender.setImage(UIImage.getUIImageByName(player.isPlaying ? "pause" : "play"), for: .normal)
        loadingImageView.isHidden = !player.isPlaying
        self.playOrPauseDanmu()
    }
    
    public func playOrPause() {
        self.playOrPause(UIButton())
    }

    @objc func tapSliderValue(sender: UITapGestureRecognizer) {
        self.resetControlViewTimer()
        let location = sender.location(in: self.progressSlider)
        let percent = Float(location.x / self.progressSlider.frame.width)
        self.seekToTime(percent * self.progressSlider.maximumValue)
    }
    
    // 开始拖动
    @objc func startToChangeSliderValue(slider: UISlider) {
        self.timeDisplay.text = "\(TimeUtil.getTimeMinutesBySeconds(Int(slider.value))):\(TimeUtil.getTimeSecondBySeconds(Int(slider.value)))/\(self.totalTime)"
        self.centerProgressDisplayLabel.isHidden = false
        self.centerProgressDisplayLabel.text = self.timeDisplay.text
        self.bottomProgressView.progress = slider.value / self.progressSlider.maximumValue
        sliderThumbFollowGesture = true
        self.stopHideControlViewTimer()
    }
    
    // 拖动结束
    @objc func changeSliderValue(slider: UISlider) {
        justDrag = 2
        self.seekToTime(slider.value)
        self.centerProgressDisplayLabel.isHidden = true
        sliderThumbFollowGesture = false
        if showControlView {
            self.startHideControlViewTimer()
        }
    }
    
    func seekToTime(_ value: Float) {
        let isPlaying = self.player.isPlaying
        player.pause()
        player.seek(to: CMTimeMakeWithSeconds(Float64(value), preferredTimescale: 64))
        self.customPlay()
        if !isPlaying {
            player.pause()
        }
        self.playBtn.setImage(UIImage.getUIImageByName(player.isPlaying ? "pause" : "play"), for: .normal)
        loadingImageView.isHidden = !player.isPlaying
        seekToTimeDanmu(time: value)
    }
    
    @objc func clickTapPlayer(_ sender: UITapGestureRecognizer) {
        clickDebounceTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(singleClick), userInfo: nil, repeats: false)
    }
    
    @objc func singleClick() {
        fadeControlView()
    }
    
    @objc func doubleTapPlayer() {
        if clickDebounceTimer != nil {
            clickDebounceTimer.invalidate()
            clickDebounceTimer = nil
        }
        playOrPause(self.playBtn)
    }

    @objc func longPressPlayer(recognizer: UILongPressGestureRecognizer) {
        self.hideControlView()
        if (recognizer.state == .began) {
            self.currentPlayerRate = self.longPressPlayRate
            self.player.pause()
            self.customPlay(isLongPress: true)
        } else {
            if (recognizer.state == .cancelled || recognizer.state == .failed || recognizer.state == .ended) {
                self.currentPlayerRate = self.playerRate
                self.player.pause()
                self.customPlay(isLongPress: true)
            }
        }
        
    }
    
    @objc func changeVolumeProgress(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: gestureView)
        let absx = abs(Int32(translation.x))
        let absy = abs(Int32(translation.y))
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
    
    @objc public func playToEnd() {
        if player == nil {
            return
        }
        playBtn.setImage(UIImage.getUIImageByName("play"), for: .normal)
        playerItem.seek(to: CMTime.zero) { (bool) in }
        player.pause()
        bottomProgressView.progress = 0
    }
    
    public func closePlayer() {
        if (player != nil) {
            player.pause()
            removePlayerObserver(playerItem: playerItem)
            player = nil
            stopHideControlViewTimer()
        }
    }
    
    private func customPlay(isLongPress: Bool = false) {
        self.player.playImmediately(atRate: self.currentPlayerRate)
        if isLongPress {
            self.rateTipView.isHidden = self.currentPlayerRate == 1.0
        }
    }
    
    public func playUrl(url: String, progress: Float = 0.0) {
//        if url == videoUrl {
////            print("地址未变化")
//            return
//        }
        guard let urlURL = URL(string: url) else {
//            print(url)
            fatalError("播放地址错误")
        }
        if player != nil {
//            print("移除")
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
        if progress > 0 {
            player.seek(to: CMTimeMakeWithSeconds(Float64(progress), preferredTimescale: 64))
        }
        startHideControlViewTimer()
        self.resetDanmuLayer()
        print(videoUrl)
    }
    
    @objc public func reset() {
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
    
    func resetDanmuLayer() {
        self.resetDanmuData()
        self.prepareDanmu()
        self.danmuLayer?.removeFromSuperlayer()
        self.danmuLayer = nil
        DispatchQueue.main.async {
            self.danmuLayer = CALayer()
            self.danmuLayer?.masksToBounds = true
            self.danmuLayer?.frame = self.bounds
            guard let danmuLayer = self.danmuLayer else {
                return
            }
            self.playerView.layer.insertSublayer(danmuLayer, above: self.playerLayer)
        }
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
        self.danmuListenTimer.invalidate()
        self.danmuListenTimer = nil
    }
}

// 控制条显示
extension DplayerView {
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
                self.resetControlViewTimer()
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
    
    @objc func resetControlViewTimer() {
        self.stopHideControlViewTimer()
        self.startHideControlViewTimer()
    }
}

// 时间显示
extension DplayerView {
    
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

// 弹幕相关设置
extension DplayerView {

    func resetDanmuData() {
        for i in 0..<self.danmuConfig.maxChannelNumber {
            self.danmuChannelDict[i] = 0
        }
        self.danmuDict = [:]
        self.danmuChannelDict = [:]
        self.danmuDictHandled = [:]
        self.latestDanmuTimes.clear()
    }
    
    // TODO: refine the logic
    func seekToTimeDanmu(time: Float) {
        print("seek to: \(time)")
        guard let danmuLayer = self.danmuLayer, let sublayers = danmuLayer.sublayers else {
            return
        }
        self.isSeekDanmu = true
        let danmuLayerWidth = danmuLayer.bounds.width
        for sublayer in sublayers {
            sublayer.removeFromSuperlayer()
        }
        return
        let shouldDisplayDuration: Float = (Float(danmuLayerWidth) / Float(self.danmuConfig.speed) / self.currentPlayerRate).roundTo(count: 1)
        let startTime = (time - shouldDisplayDuration).roundTo(count: 1)
        for secondTemp in Int(startTime * 10)..<Int((time).roundTo(count: 1) * 10) {
            let second = Float(secondTemp) / 10.0
            let currentTimeKey = second.roundTo(count: 1)
            guard let currentTimeDanmuDict = self.danmuDictHandled[currentTimeKey] else {
                continue
            }
            let currentTimeChannels = currentTimeDanmuDict.keys
            for channelNumber in currentTimeChannels {
                if let currentTimeDanmuOptional = currentTimeDanmuDict[channelNumber], let currentTimeDanmu = currentTimeDanmuOptional {
                    print(currentTimeDanmu.content)
                    let danmuTextLayer = DanmuService.generateDanmuTextLayer(danmu: currentTimeDanmu, danmuConfig: self.danmuConfig)
                    danmuTextLayer.isSeek = true
                    let hasMovedX: CGFloat = CGFloat(time - second) * self.danmuConfig.speed
                    let y: CGFloat = self.danmuConfig.channelHeight * CGFloat(channelNumber)
                    danmuTextLayer.frame = CGRect(x: danmuLayer.bounds.width, y: y, width: currentTimeDanmu.width, height: self.danmuConfig.channelHeight)
                    let animation = DanmuService.generateDanmuAnimation(duration: (danmuLayerWidth - hasMovedX) / CGFloat(self.danmuConfig.speed))
                    animation.fromValue = danmuLayerWidth + currentTimeDanmu.width - hasMovedX
                    animation.toValue = 0 - currentTimeDanmu.width
                    danmuTextLayer.add(animation, forKey: nil)
                    self.danmuLayer?.addSublayer(danmuTextLayer)
                    DanmuService.pauseLayer(layer: danmuTextLayer)
                    latestDanmuTimes.push(element: currentTimeKey)
                }
            }
        }
        self.isSeekDanmu = false
    }

    func prepareDanmu() {
        if !self.danmuConfig.enable {
            return
        }
        for danmu in self.danmus {
            if !self.danmuDict.keys.contains(danmu.time) {
                self.danmuDict[danmu.time] = []
            }
            self.danmuDict[danmu.time]?.append(danmu)
        }
        // 按照视频时长，生成每0.1s的弹幕textlayer
        // 如果当前时间点存在弹幕就均匀分布在n个弹幕轨道
        // 但是要注意当前轨道上一个弹幕layer的宽度，不能重叠，如出现重叠就尝试移动到下一个轨道，如果全部轨道都占满，则舍弃该弹幕
        // 如果当前时间点不存在弹幕就跳过
        for second in 0..<(self.totalTimeSeconds * 10) {
            let currentTime = Float(second) / 10.0
            if let currentTimeDanmus = self.danmuDict[currentTime] {
                let currentTimeChannelCount = min(currentTimeDanmus.count, self.danmuConfig.maxChannelNumber)
                for i in 0..<currentTimeChannelCount {
                    if self.danmuDictHandled[currentTime] == nil {
                        self.danmuDictHandled[currentTime] = [:]
                    }
                    
                    var currentTimeDanmu = currentTimeDanmus[i]
                    let danmuTextLayer = DanmuService.generateDanmuTextLayer(danmu: currentTimeDanmu, danmuConfig: self.danmuConfig)
                    for j in 0..<self.danmuConfig.maxChannelNumber {
                        let currentShouldWidth = CGFloat(currentTime) * CGFloat(self.danmuConfig.speed)
                        if self.danmuChannelDict[j] ?? 0.0 > currentShouldWidth {
                            continue
                        }
                        var danmuTextLayerWidth = danmuTextLayer.preferredFrameSize().width
                        danmuTextLayerWidth = max(danmuTextLayerWidth, 0.1 * CGFloat(self.danmuConfig.speed))
                        currentTimeDanmu.width = danmuTextLayerWidth
                        self.danmuDictHandled[currentTime]?[j] = currentTimeDanmu
                        let newWidth = CGFloat(currentTime) * CGFloat(self.danmuConfig.speed) + danmuTextLayerWidth
                        self.danmuChannelDict[j] = newWidth
                        break
                    }
                }
            }
        }
    }

    func playingDanmu(currentTime: Float) {
//        if self.isSeekDanmu {
//            return
//        }
        if !self.danmuConfig.enable {
            return
        }
        guard let danmuLayer = self.danmuLayer else {
            return
        }
        
        let currentTimeKey = currentTime.roundTo(count: 1)
        if self.latestDanmuTimes.value.contains(currentTimeKey) {
            return
        }
//        let speed: CGFloat = 414.0 / 6.0 * CGFloat(self.currentPlayerRate)
        if !self.danmuDict.keys.contains(currentTimeKey) {
            return
        }
        guard let currentTimeDanmus = self.danmuDict[currentTimeKey] else {
            return
        }
        let currentTimeChannelCount = min(currentTimeDanmus.count, self.danmuConfig.maxChannelNumber)
        var currentTimeHasGenerateChannelNumbers: [Int] = []
        for i in 0..<currentTimeChannelCount {
            let currentChannelDanmu = currentTimeDanmus[i]
            let danmuTextLayer = DanmuService.generateDanmuTextLayer(danmu: currentChannelDanmu, danmuConfig: self.danmuConfig)
            let size = danmuTextLayer.preferredFrameSize()

            var channelNumber = -1
            for j in 0..<self.danmuConfig.maxChannelNumber {
                if currentTimeHasGenerateChannelNumbers.contains(j) {
                    continue
                }
                guard let currentTimeDamuDict = self.danmuDictHandled[currentTimeKey], let danmu = currentTimeDamuDict[j] else {
                    continue
                }
                if danmu?.content != "" {
                    channelNumber = j
                    currentTimeHasGenerateChannelNumbers.append(j)
                    break
                }
            }

            /// 未找到合适的轨道
            if channelNumber == -1 {
                return
            }
            
//            danmuChannelDict[channelNumber]! += size.width
            let duration = (danmuLayer.bounds.width / self.danmuConfig.speed) + CGFloat(arc4random() % UInt32(3)) / 10
            let animation = DanmuService.generateDanmuAnimation(duration: duration)
            DispatchQueue.main.async {
                danmuTextLayer.frame = CGRect(x: danmuLayer.bounds.width, y: self.danmuConfig.channelHeight * CGFloat(channelNumber), width: size.width, height: self.danmuConfig.channelHeight)
                animation.fromValue = danmuLayer.bounds.width + size.width
                animation.toValue = 0 - size.width
                animation.delegate = LayerRemover(for: danmuTextLayer)
                danmuTextLayer.channel = channelNumber
                danmuTextLayer.time = currentTimeKey
                danmuTextLayer.add(animation, forKey: nil)
                self.danmuLayer?.addSublayer(danmuTextLayer)
                self.latestDanmuTimes.push(element: currentTimeKey)
                if !self.player.isPlaying {
                    DanmuService.pauseLayer(layer: danmuTextLayer)
                }
                guard let sublayers = danmuLayer.sublayers else {
                    return
                }
                for sublayer in sublayers {
                    if sublayer.speed != self.currentPlayerRate {
                        sublayer.timeOffset = sublayer.convertTime(CACurrentMediaTime(), from: nil)
                        sublayer.beginTime = CACurrentMediaTime()
                        sublayer.speed = 1.0 * self.currentPlayerRate
                    }
                }
            }
        }
    }
    
    @objc func checkDanmuLayer() {
        if self.player == nil {
            return
        }
        guard let danmuLayer = self.danmuLayer, let subLayers = danmuLayer.sublayers else {
            return
        }
        let isPlaying = self.player.isPlaying
        if isPlaying {
            return
        }
        for subLayer in subLayers {
            DanmuService.pauseLayer(layer: subLayer)
        }
    }
    
    func playOrPauseDanmu() {
        guard let danmuLayer = self.danmuLayer, let subLayers = danmuLayer.sublayers else {
            return
        }
        let isPlaying = self.player.isPlaying
        if !isPlaying {
            return
        }
        for subLayer in subLayers {
            DanmuService.resumeLayer(layer: subLayer, playerRate: self.currentPlayerRate)
        }
    }
}

extension AVPlayer {
    public var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}
