//
//  BaseView.swift
//  one
//
//  Created by sidney on 2021/12/25.
//

import Foundation
import UIKit

class BaseView: UIView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("click base view touch began \(self.tag)")
        self.superview?.touchesBegan(touches, with: event)
    }
//
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print("click base view hittest")
//        return self.superview
//    }
//
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        print("click base view point inside")
//        return true
//    }

}
