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

class DiyPlayerView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var fullBtn: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var cacheSlider: UISlider!
    
    var loadingImageView: UIImageView!
    var playerItem: AVPlayerItem!
    var player: AVPlayer! = nil
    var playerLayer: AVPlayerLayer!
    var isPlay = false
    var systemVolumeView = MPVolumeView()
    var videoUrl = ""
    var totalTimeSeconds = 0
    var totalTime = "00:00"
    var currentTime = "00:00"
    var sliderThumbFollowGesture = false
    var justDrag: Int = 0 //防止拖动播放瞬间滑块闪回
    var firstOpen = true
    
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
        // 双击播放和暂停手势
        let doubleTap = UITapGestureRecognizer(target: self, action:#selector(doubleTapPlayer))
        doubleTap.numberOfTapsRequired = 2
        self.playerView.addGestureRecognizer(doubleTap)
        // 滑动+-音量手势
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpVolume))
        swipeUp.direction = .up
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownVolume))
        swipeDown.direction = .down
        self.playerView.addGestureRecognizer(swipeUp)
        self.playerView.addGestureRecognizer(swipeDown)
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
//        let assets = AVURLAsset.audiovisualTypes()
//        assets.map { type in
//            print(type.rawValue)
//        }
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
        print("commoninit")
        contentView.frame = self.bounds
        addSubview(contentView)
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
//        progressSlider.addTarget(self, action: #selector(changeSliderValue:), for: UIControlEvents.RawValue)
        progressSlider.addTarget(self, action: #selector(changeSliderValue(slider:)), for: UIControl.Event.valueChanged)
        progressSlider.addTarget(self, action: #selector(startToChangeSliderValue(slider:)), for: UIControl.Event.touchDragInside)
    }
    
    override func layoutSubviews() {
        print("layout")
        super.layoutSubviews()
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
//         Only handle observations for the playerItemContext
//        guard context == &playerItemContext else {
//            super.observeValue(forKeyPath: keyPath,
//                               of: object,
//                               change: change,
//                               context: context)
//            return
//        }
        
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
                        }
                    }
                    
                })
                
                break
            // Player item is ready to play.
            case .failed:
                print("1111111")
                reset()
                break
            // Player item failed. See error.
            case .unknown:
                print("2222222")
                break
                // Player item is not yet ready.
            @unknown default:
                break
            }
        }
        
        if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges) {
            let cacheSeconds = Int(playerItem.loadedTimeRanges[0].timeRangeValue.duration.value) / Int(playerItem.loadedTimeRanges[0].timeRangeValue.duration.timescale)
            if totalTimeSeconds > 0 && Float(cacheSeconds) > cacheSlider.value {
                cacheSlider.value = Float(cacheSeconds)
            }
        }
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

    @objc func startToChangeSliderValue(slider:UISlider) {
        print("start slider.value = %d",slider.value)
        self.timeDisplay.text = "\(TimeUtil.getTimeMinutesBySeconds(Int(slider.value))):\(TimeUtil.getTimeSecondBySeconds(Int(slider.value)))/\(self.totalTime)"
        sliderThumbFollowGesture = true
    }
    
    @objc func changeSliderValue(slider:UISlider) {
        print("slider.value = %d",slider.value)
        justDrag = 2
        player.pause()
        player.seek(to: CMTimeMakeWithSeconds(Float64(slider.value), preferredTimescale: 64))
        player.play()
        loadingImageView.isHidden = !player.isPlaying
        self.playBtn.setImage(UIImage(named: "pause"), for: .normal)
        sliderThumbFollowGesture = false
    }
    
    @objc func doubleTapPlayer() {
        print("double tap")
        playOrPause(self.playBtn)
    }

    @objc func swipeUpVolume() {
        print("swipe up", self.getSystemVolumeValue())
        self.setSystemVolumeValue(self.getSystemVolumeValue() + 0.1)
        print("swipe up", self.getSystemVolumeValue())
    }

    @objc func swipeDownVolume() {
        print("swipe down", self.getSystemVolumeValue())
        self.setSystemVolumeValue(self.getSystemVolumeValue() - 0.1)
        print("swipe down", self.getSystemVolumeValue())
    }

    @objc func playToEnd() {
        if player == nil {
            return
        }
        playBtn.setImage(UIImage(named: "play"), for: .normal)
        playerItem.seek(to: CMTime.zero) { (bool) in }
        player.pause()
    }
    
    func closePlayer(){
        if (player != nil) {
            print("关闭播放器")
            player.pause()
            removePlayerObserver(playerItem: playerItem)
            player = nil
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
        }
        
        let asset = AVAsset(url: urlURL)
        playerItem = AVPlayerItem(asset: asset)
        addPlayerObserver(playerItem: playerItem)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        playerLayer.frame = self.bounds
        playerView.layer.insertSublayer(playerLayer, at: 0)
        playOrPause(self.playBtn)
        videoUrl = url
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

extension AVPlayer {
    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}
