//
//  AnimationUtils.swift
//  one
//
//  Created by sidney on 2021/6/7.
//

import Foundation
import UIKit

/// 构建动画
class AnimationUtils {
    
    /// 自转动画的添加、暂停和恢复（类似于地球自转）
    static func addRotate(layer: CALayer) {
        layer.add(getRotateAmination(), forKey: "musicPosterRotate")
        pauseRotate(layer: layer)
    }
    
    static func getRotateAmination() -> CABasicAnimation {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.duration = 40
        rotateAnimation.repeatCount = MAXFLOAT
        rotateAnimation.isRemovedOnCompletion = false // 切出其他控制器不会暂停
        // rotateAnimation.autoreverses = true //自动反向一次
        return rotateAnimation
    }
    
    static func pauseRotate(layer: CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.timeOffset = pausedTime
        layer.speed = 0.0
    }
    
    static func resumeRotate(layer: CALayer) {
        let pauseTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let sincePauseTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        layer.beginTime = sincePauseTime
    }
    
    static func resetRotate(layer: CALayer) {
        layer.beginTime = 0.0
        layer.speed = 0.0
        layer.removeAnimation(forKey: "musicPosterRotate")
        AnimationUtils.addRotate(layer: layer)
    }
    
    /// 公转动画的开始、停止（类似于地球绕太阳公转）
    // @clockwise: 是否顺时针
    // @compensation: 弧度补偿，默认为0.0
    static func startRevolutionRotate(earth: UIView, sun: UIView, clockwise: Bool, compensation: CGFloat = 0) {
        earth.layer.add(getRevolutionRotateAnimation(sun: sun.center, earth: earth.center, clockwise: clockwise, compensation: compensation), forKey: nil)
    }

    static func stopRevolutionRotate(earth: UIView) {
        if let position = earth.layer.presentation()?.position {
            earth.center = position
        }
        earth.layer.removeAllAnimations()
    }

    static func getRevolutionRotateAnimation(sun: CGPoint, earth: CGPoint, clockwise: Bool, compensation: CGFloat = 0) -> CAKeyframeAnimation {
        let distance = CGPoint.distance(p1: sun, p2: earth)
        var angle = CGPoint.angle(from: sun, to: earth) // 笛卡尔坐标系方位角
        angle = angle - .pi
        angle = clockwise ? (angle + compensation) : (angle - compensation)
        let startAngle = clockwise ? angle : (angle + .pi * 2)
        let endAngle = clockwise ? (angle + .pi * 2) : angle
        let rotatePath = UIBezierPath(arcCenter: sun, radius: distance, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        animation.path = rotatePath.cgPath
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    static func getTransition(duration: Double, functionName: CAMediaTimingFunctionName) -> CATransition {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: functionName)
        return transition
    }
}
