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
let STATUS_BAR_HEIGHT = CGFloat(hasNotch ? 44.0 : 20.0)
let leftVcleftVcVisibleViewWidthPercent = CGFloat(0.85)

var hasNotch: Bool {
    return (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) > 0
}
 
func modelIdentifier() -> String {
    if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
    var sysinfo = utsname()
    uname(&sysinfo) // ignore return value
    return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
}

