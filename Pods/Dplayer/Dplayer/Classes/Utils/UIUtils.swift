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
