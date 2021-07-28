//
//  Danmu.swift
//  Dplayer
//
//  Created by sidney on 2021/7/28.
//
import Foundation

public struct DanmuConfig {
    public init() {}
    public var enable: Bool = true
    public var channelHeight: CGFloat = 22.0
    public var maxChannelNumber: Int = 10
    public var defaultFontColor: UIColor = UIColor.white.withAlphaComponent(0.7)
    public var defaultFontSize: CGFloat = 17.0
    public var speed: CGFloat = 414.0 / 8.0
}

public struct Danmu {
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
}

class DanmuService {

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

    static func generateDanmuTextLayer(danmu: Danmu, danmuConfig: DanmuConfig) -> CustomCATextLayer {
        let danmuTextLayer = CustomCATextLayer()
        danmuTextLayer.foregroundColor = danmu.color == UIColor.clear ? danmuConfig.defaultFontColor.cgColor : danmu.color.cgColor
        let defaultFontSize = danmu.fontSize == 0.0 ? danmuConfig.defaultFontSize : danmu.fontSize
        danmuTextLayer.font = UIFont.systemFont(ofSize: defaultFontSize)
        danmuTextLayer.fontSize = defaultFontSize
        danmuTextLayer.string = danmu.content
        danmuTextLayer.alignmentMode = .center
        danmuTextLayer.contentsScale = UIScreen.main.scale
        return danmuTextLayer
    }
}
