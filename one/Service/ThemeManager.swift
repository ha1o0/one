//
//  ThemeManager.swift
//  one
//
//  Created by sidney on 6/9/21.
//

import Foundation
import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    
    var defaultBlurStyle: [UIUserInterfaceStyle: UIBlurEffect.Style] = [.light: .extraLight, .dark: .dark]
    var defaultBarColor: [UIUserInterfaceStyle: [UIColor]] = [.light: [.main, .tabBarGray], .dark: [.white, .tabBarGray]]
    var currentInterfaceStyle: UIUserInterfaceStyle = .light
    
    
    private init() {
        self.updateInterfaceStyle()
        NotificationService.shared.listenInterfaceStyleChange(target: self, selector: #selector(changeInterfaceStyle))
    }
    
    func getBlurStyle() -> UIBlurEffect.Style {
        return self.defaultBlurStyle[currentInterfaceStyle]!
    }
    
    func getBarColor() -> [UIColor] {
        return self.defaultBarColor[currentInterfaceStyle]!
    }
    
    func updateInterfaceStyle() {
        guard let window = appDelegate.window else {
            return
        }
        self.currentInterfaceStyle = window.traitCollection.userInterfaceStyle
    }
    
    @objc func changeWindowInterfaceStyle() {
        appDelegate.window?.overrideUserInterfaceStyle = currentInterfaceStyle == .light ? .dark : .light
    }
    
    @objc func changeInterfaceStyle() {
        
    }
}
