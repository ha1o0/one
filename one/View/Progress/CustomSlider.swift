//
//  CustomSlider.swift
//  one
//
//  Created by sidney on 6/24/21.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    var sliderTrackHeight: CGFloat = 2
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.trackRect(forBounds: bounds)
        return CGRect(origin: CGPoint(x: originalRect.origin.x, y: originalRect.origin.y + (sliderTrackHeight / 2)), size: CGSize(width: bounds.width, height: sliderTrackHeight))
    }
}
