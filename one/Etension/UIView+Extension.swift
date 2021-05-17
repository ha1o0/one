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
    
    func setAnchor(anchorPoint: CGPoint) {
        let oldOrigin = self.frame.origin
        self.layer.anchorPoint = anchorPoint
        let newOrigin = self.frame.origin
        var transition: CGPoint = .zero
        transition.x = newOrigin.x - oldOrigin.x
        transition.y = newOrigin.y - oldOrigin.y
        self.center = CGPoint(x: self.center.x - transition.x, y: self.center.y - transition.y)
    }
    
    func resetAnchor() {
        var anchorPoint: CGPoint = .zero
        let superViewCenter = self.superview!.center;
        let viewPoint: CGPoint = self.convert(superViewCenter, from: self.superview?.superview)
        anchorPoint.x = viewPoint.x / self.bounds.size.width
        anchorPoint.y = viewPoint.y / self.bounds.size.height
        setAnchor(anchorPoint: anchorPoint)
    }
    
    func setAnchorPoint(anchorPoint: CGPoint) {
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        var newPoint = CGPoint(x: width * anchorPoint.x, y: height * anchorPoint.y)
        var oldPoint = CGPoint(x: width * self.layer.anchorPoint.x, y: height * self.layer.anchorPoint.y)
        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)
        
        var position = self.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        self.layer.position = position
        self.layer.anchorPoint = anchorPoint
    }
}

extension UIButton {
    static func getSystemIconBtn(name: String, color: UIColor, size: CGFloat = 25) -> UIButton {
        let btn = UIButton()
        btn.tintColor = color
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(systemName: name), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
        return btn
    }
}
