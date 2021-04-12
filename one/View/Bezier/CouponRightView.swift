//
//  CouponRightView.swift
//  one
//
//  Created by sidney on 4/12/21.
//

import UIKit

class CouponRightView: UIView {
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    override func draw(_ rect: CGRect) {
        let cornerRadius: CGFloat = 10
        let path = UIBezierPath()
        let oWidth = self.bounds.width
        let oHeight = self.bounds.height
        let toplefty: CGPoint = CGPoint(x: 0, y: cornerRadius)
        let topleftCenter: CGPoint = CGPoint(x: 0, y: 0)
        let toprightx: CGPoint = CGPoint(x: oWidth, y: 0)
        let toprightCenter: CGPoint = CGPoint(x: oWidth - cornerRadius, y: cornerRadius)
        let bottomleftx: CGPoint = CGPoint(x: cornerRadius, y: oHeight)
        let bottomleftCenter: CGPoint = CGPoint(x: 0, y: oHeight)
        let bottomrighty: CGPoint = CGPoint(x: oWidth, y: oHeight - cornerRadius)
        let bottomrightCenter: CGPoint = CGPoint(x: oWidth - cornerRadius, y: oHeight - cornerRadius)

        path.move(to: toplefty)
        path.addArc(withCenter: topleftCenter, radius: cornerRadius, startAngle: .pi * 3 / 2, endAngle: 0, clockwise: false)
        path.addLine(to: toprightx)
        path.addArc(withCenter: toprightCenter, radius: cornerRadius, startAngle: .pi * 3 / 2, endAngle: 0, clockwise: true)
        path.addLine(to: bottomrighty)
        path.addArc(withCenter: bottomrightCenter, radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        path.addLine(to: bottomleftx)
        path.addArc(withCenter: bottomleftCenter, radius: cornerRadius, startAngle: 0, endAngle: .pi / 2, clockwise: false)
        path.close()
        path.lineWidth = 1
        UIColor.white.setFill()
        path.fill()
    }
}
