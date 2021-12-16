//
//  Emitterable.swift
//  one
//
//  Created by sidney on 12/16/21.
//

import Foundation
import UIKit

protocol Emitterable {

}

extension Emitterable where Self: UIViewController {
    func startEmittering(_ point: CGPoint) {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = point
        emitter.preservesDepth = false
        let cell = CAEmitterCell()
        cell.velocity = 150
        cell.velocityRange = 100
        cell.scale = 0.3
        cell.scaleRange = 0.1
        cell.lifetime = 3
        cell.lifetimeRange = 1.5
        cell.emissionLongitude = CGFloat.pi / 2
        cell.emissionRange = CGFloat.pi / 6
        cell.spin = CGFloat.pi / 2
        cell.spinRange = CGFloat.pi / 4
        cell.birthRate = 2
        cell.contents = UIImage(named: "sliderThumb1")?.cgImage
        emitter.emitterCells = [cell, cell, cell, cell, cell, cell]
        view.layer.addSublayer(emitter)
    }
    
    func stopEmittering() {
        view.layer.sublayers?.filter({ (calayer) -> Bool in
            return calayer.isKind(of: CAEmitterLayer.self)
        }).first?.removeFromSuperlayer()
    }
}
