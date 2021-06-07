//
//  CGPoint+Extension.swift
//  one
//
//  Created by sidney on 2021/6/7.
//

import Foundation
import UIKit

extension CGPoint {
    
    // 计算两点之间的距离
    static func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return sqrt(pow((p2.x - p1.x), 2) + pow((p2.y - p1.y), 2))
    }
    
    // 计算反正切角
    static func angle(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        return atan2((p1.y - p2.y), (p1.x - p2.x))
    }
}
