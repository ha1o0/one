//
//  CouponLeftView.swift
//  one
//
//  Created by sidney on 4/12/21.
//

import UIKit

class CouponLeftView: UIView {
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    override func draw(_ rect: CGRect) {
        let cornerRadius: CGFloat = 10
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [], cornerRadii: 10)
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
        let path = UIBezierPath()
        let oWidth = self.bounds.width
        let oHeight = self.bounds.height
        let toplefty: CGPoint = CGPoint(x: 0, y: cornerRadius)
        let topleftCenter: CGPoint = CGPoint(x: cornerRadius, y: cornerRadius)
        let bottomleftx: CGPoint = CGPoint(x: cornerRadius, y: oHeight)
        let bottomleftCenter: CGPoint = CGPoint(x: cornerRadius, y: oHeight - cornerRadius)
        let toprightx: CGPoint = CGPoint(x: oWidth - cornerRadius, y: 0)
        let toprightCenter: CGPoint = CGPoint(x: oWidth, y: 0)
        let bottomrighty: CGPoint = CGPoint(x: oWidth, y: oHeight - cornerRadius)
        let bottomrightCenter: CGPoint = CGPoint(x: oWidth, y: oHeight)
        path.move(to: toplefty)
        path.addArc(withCenter: topleftCenter, radius: cornerRadius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: true)
        path.addLine(to: toprightx)
        path.addArc(withCenter: toprightCenter, radius: cornerRadius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: false)
        path.addLine(to: bottomrighty)
        path.addArc(withCenter: bottomrightCenter, radius: cornerRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
        path.addLine(to: bottomleftx)
        path.addArc(withCenter: bottomleftCenter, radius: cornerRadius, startAngle: .pi * 3 / 2, endAngle: .pi, clockwise: true)
        path.close()
        path.lineWidth = 1
        UIColor.main.setFill()
//        UIColorRed.setStroke()
        path.fill()
//        path.stroke()
    }
}
