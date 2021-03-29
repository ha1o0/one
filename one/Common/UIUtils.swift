import UIKit

public func viewFromNib<T: UIView>(_ nibName: String) -> T {
    return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! T
}

public func registerNibWithName(_ nibName: String, tableView: UITableView) {
    tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    
}

public func registerCellWithClass(_ clazz: AnyClass, tableView: UITableView) {
    tableView.register(clazz, forCellReuseIdentifier: "\(clazz.self)")
}

public func registerNibWithName(_ nibName: String, collectionView: UICollectionView) {
    collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
}

public func dequeueReusableCell(withIdentifier: String, tableView: UITableView) -> UITableViewCell? {
    if let cell = tableView.dequeueReusableCell(withIdentifier: withIdentifier) {
        return cell
    } else {
        registerNibWithName(withIdentifier, tableView: tableView)
        return tableView.dequeueReusableCell(withIdentifier: withIdentifier)
    }
}

public func getCuttingImage(_ size: CGSize, direction: UIRectCorner, cornerRadii: CGFloat, borderWidth: CGFloat, borderColor: UIColor, backgroundColor: UIColor) -> UIImage? {
    let width = size.width
    let height = size.height

    // 先利用CoreGraphics绘制一个圆角矩形
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    guard let currentContext = UIGraphicsGetCurrentContext() else {
        UIGraphicsEndImageContext()
        return nil
    }
    currentContext.setFillColor(backgroundColor.cgColor)// 设置填充颜色
    currentContext.setStrokeColor(borderColor.cgColor)// 设置画笔颜色
    
    // 单切圆角
    if direction == UIRectCorner.allCorners {
        currentContext.move(to: CGPoint(x: width - borderWidth, y: cornerRadii + borderWidth))// 从右下开始
        currentContext.addArc(tangent1End: CGPoint(x: width - borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: width - cornerRadii - borderWidth, y: height - borderWidth), radius: cornerRadii)
        currentContext.addArc(tangent1End: CGPoint(x: borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: borderWidth, y: height - cornerRadii - borderWidth), radius: cornerRadii)
        currentContext.addArc(tangent1End: CGPoint(x: borderWidth, y: borderWidth), tangent2End: CGPoint(x: width - borderWidth, y: borderWidth), radius: cornerRadii)
        currentContext.addArc(tangent1End: CGPoint(x: width - borderWidth, y: borderWidth), tangent2End: CGPoint(x: width - borderWidth, y:  cornerRadii + borderWidth), radius: cornerRadii)
    } else {
        currentContext.move(to: CGPoint.init(x: cornerRadii + borderWidth, y: borderWidth))// 从左上开始
        if direction.contains(UIRectCorner.topLeft) {
            currentContext.addArc(tangent1End: CGPoint(x: borderWidth, y: borderWidth), tangent2End: CGPoint(x: borderWidth, y: cornerRadii + borderWidth), radius: cornerRadii)
        } else {
            currentContext.addLine(to: CGPoint.init(x: borderWidth, y: borderWidth))
        }
        if direction.contains(UIRectCorner.bottomLeft) {
            currentContext.addArc(tangent1End: CGPoint(x: borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: borderWidth + cornerRadii, y: height - borderWidth), radius: cornerRadii)
        } else {
            currentContext.addLine(to: CGPoint(x: borderWidth, y: height - borderWidth))
        }
        if direction.contains(UIRectCorner.bottomRight) {
            currentContext.addArc(tangent1End: CGPoint(x: width - borderWidth, y: height - borderWidth), tangent2End: CGPoint(x: width - borderWidth, y: height - borderWidth - cornerRadii), radius: cornerRadii)
        } else {
            currentContext.addLine(to: CGPoint(x: width - borderWidth, y: height - borderWidth))
        }
        if direction.contains(UIRectCorner.topRight) {
            currentContext.addArc(tangent1End: CGPoint(x: width - borderWidth, y: borderWidth), tangent2End: CGPoint(x: width - borderWidth - cornerRadii, y: borderWidth), radius: cornerRadii)
        } else {
            currentContext.addLine(to: CGPoint(x: width - borderWidth, y: borderWidth))
        }
        currentContext.addLine(to: CGPoint(x: borderWidth + cornerRadii, y: borderWidth))
    }
    currentContext.drawPath(using: .fillStroke)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
}

//var rootNavigationController: UINavigationController? {
//    let rootContentVC = (appDelegate.window?.rootViewController as? SideMenuController)?.contentViewController
//    var nc = rootContentVC?.navigationController
//    if let rootVC = rootContentVC as? UITabBarController {
//        let selectedChild = rootVC.children[safe: rootVC.selectedIndex]
//        if let vc = selectedChild as? UINavigationController {
//            nc = vc
//        } else {
//            nc = selectedChild?.navigationController
//        }
//    }
//    return nc
//}
//
var topViewController: UIViewController? {
    return appDelegate.window?.rootViewController
//    var vc = (appDelegate.window?.rootViewController as? SideMenuController)?.contentViewController
//    if let rootVC = vc as? UITabBarController {
//        if rootVC.children.count > rootVC.selectedIndex {
//            let selectedChild = rootVC.children[safe: rootVC.selectedIndex]
//            if let nc = selectedChild as? UINavigationController {
//                vc = nc.topViewController
//            } else {
//                vc = selectedChild
//            }
//        } else {
//            vc = rootVC
//        }
//    }
//    while vc?.presentedViewController != nil {
//        vc = vc?.presentedViewController
//    }
//    return vc
}

//public func getTargetControllerInNavStacks(target: AnyClass) -> UIViewController? {
//    let stackVcs: [UIViewController] = rootNavigationController?.children ?? []
//    for vc in stackVcs {
//        if vc.isKind(of: target) {
//            return vc
//        }
//    }
//    return nil
//}

public func getLabelHeight(text: String, font: UIFont, width: CGFloat, lineSpacing: CGFloat) -> CGFloat {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    if lineSpacing > 0.0 {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = .center
        label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: style])
    } else {
        label.text = text
    }
    label.sizeToFit()
    return label.frame.height
}

public func pt(_ px: CGFloat) -> CGFloat {
    return SCREEN_WIDTH * (px/375)
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
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
