//
//  BaseWindow.swift
//  one
//
//  Created by sidney on 6/9/21.
//

import Foundation
import UIKit

class BaseWindow: UIWindow {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("changemode: \(self.traitCollection.userInterfaceStyle.rawValue)")
        ThemeManager.shared.currentInterfaceStyle = self.traitCollection.userInterfaceStyle
        NotificationService.shared.interfaceStyleChange(style: self.traitCollection.userInterfaceStyle)
    }
}
