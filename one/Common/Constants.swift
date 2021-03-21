 //
//  Constants.swift
//  diyplayer
//
//  Created by sidney on 2018/8/28.
//  Copyright © 2018年 sidney. All rights reserved.
//

import Foundation
import UIKit

let SECONDS_PER_MINUTE = 60
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let STATUS_BAR_HEIGHT = (UIApplication.shared.delegate as! AppDelegate).window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
 
var hasSafeArea: Bool {
 guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
     return false
 }
 return true
}
