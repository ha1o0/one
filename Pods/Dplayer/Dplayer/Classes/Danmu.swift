//
//  Danmu.swift
//  Dplayer
//
//  Created by sidney on 2021/7/28.
//
import Foundation
import AVFoundation

public struct DanmuConfig {
    public init() {}
    public var enable: Bool = true
    public var channelHeight: CGFloat = 22.0
    public var maxChannelNumber: Int = 10
    public var defaultFontColor: UIColor = UIColor.white.withAlphaComponent(0.7)
    public var defaultFontSize: CGFloat = 17.0
    public var speed: CGFloat = 414.0 / 8.0
    public var mode: DanmuMode = .video
}

public struct DanmuModel {
    public init() {}
    public var id: String = ""
    public var author: String = ""
    public var content: String = ""
    public var color: UIColor = .clear
    public var fontSize: CGFloat = 0.0
    public var time: Float = 0
    public var createdAt: Date = Date()
    public var like: Int = 0
    public var width: CGFloat = 0
    public var isSelf: Bool = false
}

public protocol DanmuDelegate: AnyObject {
    func getPlayerView() -> DplayerView?
    func getPlayer() -> AVPlayer?
    func getPlayerLayer() -> CALayer?
    func getPlayerRate() -> Float
    func getTotalTimeSeconds() -> Int
}

public enum DanmuMode {
    case live
    case video
}

public class Danmu {

    public var danmuConfig: DanmuConfig = DanmuConfig()
    public var danmus: [DanmuModel] = []
    public var danmuLayer: CALayer?
    public weak var delegate: DanmuDelegate?
    var selfDanmuDict: [Float: [DanmuModel]] = [:]
    var danmuDict: [Float: [DanmuModel]] = [:]
    var danmuChannelDict: [Int: CGFloat] = [:]
    var danmuDictHandled: [Float: [Int: DanmuModel?]] = [:]
    var latestDanmuTimes: CapacityArray<Float> = CapacityArray<Float>(capacity: 5)
    var isSeekDanmu = false
    var danmuListenTimer: Timer!
    
    public init() {}
    
    func resetDanmuLayer() {
        guard let playerView = self.delegate?.getPlayerView(), let playerLayer = self.delegate?.getPlayerLayer() else {
            return
        }
        self.resetDanmuData()
        self.prepareDanmu()
        if self.danmuLayer != nil {
            self.danmuLayer?.removeFromSuperlayer()
            self.danmuLayer = nil
        }
        self.danmuLayer = CALayer()
        self.danmuLayer?.masksToBounds = true
        self.danmuLayer?.frame = playerView.bounds
        guard let danmuLayer = self.danmuLayer else {
            return
        }
        playerView.layer.insertSublayer(danmuLayer, above: playerLayer)
        
    }
    
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
        guard let danmuLayer = self.danmuLayer, let sublayers = danmuLayer.sublayers, let currentPlayerRate = self.delegate?.getPlayerRate() else {
            return
        }
        self.isSeekDanmu = true
        let danmuLayerWidth = danmuLayer.bounds.width
        for sublayer in sublayers {
            sublayer.removeFromSuperlayer()
        }
        return
        let shouldDisplayDuration: Float = (Float(danmuLayerWidth) / Float(self.danmuConfig.speed) / currentPlayerRate).roundTo(count: 1)
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
                    let danmuTextLayer = Danmu.generateDanmuTextLayer(danmu: currentTimeDanmu, danmuConfig: self.danmuConfig)
                    danmuTextLayer.isSeek = true
                    let hasMovedX: CGFloat = CGFloat(time - second) * self.danmuConfig.speed
                    let y: CGFloat = self.danmuConfig.channelHeight * CGFloat(channelNumber)
                    danmuTextLayer.frame = CGRect(x: danmuLayer.bounds.width, y: y, width: currentTimeDanmu.width, height: self.danmuConfig.channelHeight)
                    let animation = Danmu.generateDanmuAnimation(duration: (danmuLayerWidth - hasMovedX) / CGFloat(self.danmuConfig.speed))
                    animation.fromValue = danmuLayerWidth + currentTimeDanmu.width - hasMovedX
                    animation.toValue = 0 - currentTimeDanmu.width
                    danmuTextLayer.add(animation, forKey: nil)
                    self.danmuLayer?.addSublayer(danmuTextLayer)
                    Danmu.pauseLayer(layer: danmuTextLayer)
                    latestDanmuTimes.push(element: currentTimeKey)
                }
            }
        }
        self.isSeekDanmu = false
    }
    
    func prepareDanmu() {
        guard let totalTimeSeconds = self.delegate?.getTotalTimeSeconds() else {
            return
        }
        if !self.danmuConfig.enable {
            return
        }
        if self.danmuConfig.mode == .live {
            self.resetDanmuData()
            return
        }
        self.danmuListenTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(checkDanmuLayer), userInfo: nil, repeats: true)
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
        for second in 0..<(totalTimeSeconds * 10) {
            let currentTime = Float(second) / 10.0
            if let currentTimeDanmus = self.danmuDict[currentTime] {
                let currentTimeChannelCount = min(currentTimeDanmus.count, self.danmuConfig.maxChannelNumber)
                for i in 0..<currentTimeChannelCount {
                    var currentTimeDanmu = currentTimeDanmus[i]
                    if currentTimeDanmu.isSelf {
                        if self.selfDanmuDict[currentTime] == nil {
                            self.selfDanmuDict[currentTime] = []
                        }
                        self.selfDanmuDict[currentTime]?.append(currentTimeDanmu)
                        continue
                    }
                    if self.danmuDictHandled[currentTime] == nil {
                        self.danmuDictHandled[currentTime] = [:]
                    }
                    let danmuTextLayer = Danmu.generateDanmuTextLayer(danmu: currentTimeDanmu, danmuConfig: self.danmuConfig)
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
        if let currentTimeSelfDanmus = self.selfDanmuDict[currentTimeKey] {
            let currentTimeChannelCount = min(currentTimeSelfDanmus.count, self.danmuConfig.maxChannelNumber)
            for i in 0..<currentTimeChannelCount {
                let currentTimeSelfDanmu = currentTimeSelfDanmus[i]
                self.putDanmuTextLayer(danmu: currentTimeSelfDanmu, channelNumber: i, currentTimeKey: currentTimeKey, danmuLayer: danmuLayer)
            }
        }
        guard let currentTimeDanmus = self.danmuDict[currentTimeKey] else {
            return
        }
        let currentTimeChannelCount = min(currentTimeDanmus.count, self.danmuConfig.maxChannelNumber)
        var currentTimeHasGenerateChannelNumbers: [Int] = []
        for i in 0..<currentTimeChannelCount {
            let currentChannelDanmu = currentTimeDanmus[i]
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
            self.putDanmuTextLayer(danmu: currentChannelDanmu, channelNumber: channelNumber, currentTimeKey: currentTimeKey, danmuLayer: danmuLayer)
        }
    }
    
    func putDanmuTextLayer(danmu: DanmuModel, channelNumber: Int, currentTimeKey: Float, danmuLayer: CALayer) {
        let danmuTextLayer = Danmu.generateDanmuTextLayer(danmu: danmu, danmuConfig: self.danmuConfig)
        let duration = (danmuLayer.bounds.width / self.danmuConfig.speed) + CGFloat(arc4random() % UInt32(3)) / 10
        let animation = Danmu.generateDanmuAnimation(duration: duration)
        let size = danmuTextLayer.preferredFrameSize()
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
            if let player = self.delegate?.getPlayer() {
                if !player.isPlaying {
                    Danmu.pauseLayer(layer: danmuTextLayer)
                }
            }
            guard let sublayers = danmuLayer.sublayers, let currentPlayerRate = self.delegate?.getPlayerRate() else {
                return
            }
            for sublayer in sublayers {
                if sublayer.speed != currentPlayerRate {
                    sublayer.timeOffset = sublayer.convertTime(CACurrentMediaTime(), from: nil)
                    sublayer.beginTime = CACurrentMediaTime()
                    sublayer.speed = 1.0 * currentPlayerRate
                }
            }
        }
    }
    
    @objc func checkDanmuLayer() {
        guard let danmuLayer = self.danmuLayer, let subLayers = danmuLayer.sublayers, let player = self.delegate?.getPlayer() else {
            return
        }
        if player.isPlaying {
            return
        }
        for subLayer in subLayers {
            Danmu.pauseLayer(layer: subLayer)
        }
    }
    
    func playOrPauseDanmu() {
        guard let danmuLayer = self.danmuLayer, let subLayers = danmuLayer.sublayers,
              let player = self.delegate?.getPlayer(), let currentPlayerRate = self.delegate?.getPlayerRate() else {
            return
        }
        if !player.isPlaying {
            return
        }
        for subLayer in subLayers {
            Danmu.resumeLayer(layer: subLayer, playerRate: currentPlayerRate)
        }
    }
    
    public func sendDanmu(danmu: inout DanmuModel) {
        guard let player = self.delegate?.getPlayer(), let danmuLayer = self.danmuLayer else {
            return
        }
        let currentTime = player.currentTime()
        let currentTimeKey = Float(CMTimeGetSeconds(currentTime)).roundTo(count: 1)
        danmu.time = currentTimeKey
//        if self.danmuDictHandled[currentTimeKey] == nil {
//            self.danmuDictHandled[currentTimeKey] = [:]
//        }
        let randomChannelNumber = Int(arc4random() % UInt32(min(self.danmuConfig.maxChannelNumber, 9)))
        self.putDanmuTextLayer(danmu: danmu, channelNumber: randomChannelNumber, currentTimeKey: currentTimeKey, danmuLayer: danmuLayer)
    }
    
    static func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    static func resumeLayer(layer: CALayer, playerRate: Float) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0 * playerRate
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }

    static func generateDanmuAnimation(duration: CGFloat) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.duration = CFTimeInterval(duration)
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = .removed

        return animation
    }

    static func generateDanmuTextLayer(danmu: DanmuModel, danmuConfig: DanmuConfig) -> CustomCATextLayer {
        let danmuTextLayer = CustomCATextLayer()
        danmuTextLayer.foregroundColor = danmu.color == UIColor.clear ? danmuConfig.defaultFontColor.cgColor : danmu.color.cgColor
        let defaultFontSize = danmu.fontSize == 0.0 ? danmuConfig.defaultFontSize : danmu.fontSize
        danmuTextLayer.font = UIFont.systemFont(ofSize: defaultFontSize)
        danmuTextLayer.fontSize = defaultFontSize
        danmuTextLayer.string = danmu.content
        danmuTextLayer.alignmentMode = .center
        danmuTextLayer.contentsScale = UIScreen.main.scale
        if danmu.isSelf {
            danmuTextLayer.borderWidth = 1
            danmuTextLayer.borderColor = danmuTextLayer.foregroundColor
        }
        return danmuTextLayer
    }
    
    deinit {
        print("deinit danmu")
        if self.danmuListenTimer != nil  {
            self.danmuListenTimer.invalidate()
            self.danmuListenTimer = nil
        }
    }
}
