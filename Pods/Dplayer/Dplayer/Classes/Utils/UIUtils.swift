import UIKit

public func getBundle() -> Bundle {
    let bundlePath = URL(fileURLWithPath: Bundle(for: DplayerView.self).resourcePath ?? "").appendingPathComponent("/Dplayer.bundle").path
    let resource_bundle = Bundle(path: bundlePath) ?? Bundle(for: DplayerView.self)
//    print(resource_bundle)
    return resource_bundle
}

public func viewFromNib<T: UIView>(_ nibName: String) -> T {
    return getBundle().loadNibNamed(nibName, owner: nil, options: nil)?.first as! T
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

class CustomCATextLayer: CATextLayer {
    var time: Float = 0.0
    var channel: Int = 0
    var isSeek = false
}

class LayerRemover: NSObject, CAAnimationDelegate {
    private weak var layer: CALayer?

    init(for layer: CALayer) {
        self.layer = layer
        super.init()
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        layer?.removeFromSuperlayer()
    }
}

struct CapacityArray<T> {
    var value: [T] = []
    var capacity: Int = 5
    
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    mutating func push(element: T) {
        if self.value.count >= self.capacity {
            self.value.remove(at: 0)
        }
        self.value.append(element)
    }
    
    mutating func clear() {
        self.value = []
    }
}

extension Float {
    func roundTo(count: Int) -> Float {
        let divisor = pow(10, Float(count))
        return (self * divisor).rounded() / divisor
    }
}
