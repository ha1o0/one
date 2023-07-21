//
//  UIView+Extension.swift
//  one
//
//  Created by sidney on 2021/3/21.
//

import Foundation
import UIKit

extension UIView {
    //返回该view所在的父view
    func superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
    
    func setRoundCorners(corners: UIRectCorner, with radii:CGFloat){
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))

        let maskLayer: CAShapeLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
    }
    
    //设置阴影
    func setShadow(sColor: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        self.layoutIfNeeded()
        self.layer.shadowColor = sColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    //设置渐变背景色
    func setGradientBackgroundColor(colors: [Any], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint) {
        self.layoutIfNeeded()
        let layer = CAGradientLayer()

        layer.frame = self.bounds

        //设置颜色
        layer.colors = colors

        //设置颜色渐变的位置
        layer.locations = locations

        //开始的坐标点
        layer.startPoint = startPoint

        //结束的坐标点
        layer.endPoint = endPoint

        //设置渐变背景色后，view上面的内容无法显示，所以将layer放在最底层
        self.layer.insertSublayer(layer, at: 0)
    }
    
    // 旋转view
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }
    
    func rotateView(clockwise: Bool, degrees: CGFloat) {
        // 计算旋转角度的弧度值
        let radians = degrees * .pi / 180
        // 设置旋转方向，顺时针或逆时针
        let rotationDirection: CGFloat = clockwise ? 1 : -1
        // 创建一个旋转的变换矩阵
        let rotationTransform = CGAffineTransform(rotationAngle: rotationDirection * radians)
        // 如果希望在动画中旋转视图
        UIView.animate(withDuration: 1.0) {
            self.transform = rotationTransform
        }
        // 如果希望立即旋转视图，而不是使用动画，可以直接设置 transform 属性：
        // self.transform = rotationTransform
    }
}
