//
//  DoubleCircle.swift
//  one
//
//  Created by sidney on 4/12/21.
//

import UIKit

class DoubleCircle: UIView {
    /// 生成圆环（可配置内外圆环的填充与否，因此也可生成单圆）
    var innerRadius: CGFloat = 0
    var outerLineWidth: CGFloat = 1
    var innerLineWidth: CGFloat = 1
    var outerColor: UIColor = UIColor.gray
    var innerColor: UIColor = UIColor.gray
    var isInnerEmpty: Bool = true
    var isOuterEmpty: Bool = true
    
    convenience init(innerRadius: CGFloat, outerLineWidth: CGFloat, innerLineWidth: CGFloat, outerColor: UIColor, innerColor: UIColor, isInnerEmpty: Bool, isOuterEmpty: Bool) {
        self.init()
        self.innerRadius = innerRadius
        self.outerLineWidth = outerLineWidth
        self.innerLineWidth = innerLineWidth
        self.outerColor = outerColor
        self.innerColor = innerColor
        self.isInnerEmpty = isInnerEmpty
        self.isOuterEmpty = isOuterEmpty
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()


        // draw outer circle
        context?.setLineWidth(outerLineWidth)
        context?.setFillColor(outerColor.cgColor)
        context?.setStrokeColor(outerColor.cgColor)

        let outerRadius: CGFloat = frame.size.width / 2
        context?.addArc(center: CGPoint(x: outerRadius, y: outerRadius), radius: outerRadius - 1, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        context?.drawPath(using: isOuterEmpty ? .stroke : .fillStroke)
        if innerRadius >= outerRadius || innerRadius <= 0 {
            return
        }

        // draw inner circle
        context?.setLineWidth(innerLineWidth)
        context?.setFillColor(innerColor.cgColor)
        context?.setStrokeColor(innerColor.cgColor)
        context?.addArc(center: CGPoint(x: outerRadius, y: outerRadius), radius: innerRadius - 1, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
        context?.drawPath(using: isInnerEmpty ? .stroke : .fillStroke)
    }
}
