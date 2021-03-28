//
//  TimeUtil.swift
//  diyplayer
//
//  Created by sidney on 2018/8/28.
//  Copyright © 2018年 sidney. All rights reserved.
//

import Foundation

class TimeUtil {
    
    static func getTimeSecondBySeconds(_ seconds: Int) -> String {
        let secondResult = seconds % SECONDS_PER_MINUTE
        return secondResult < 10 ? "0\(secondResult)" : "\(secondResult)"
    }
    
    static func getTimeMinutesBySeconds(_ seconds: Int) -> String {
        let secondResult = seconds / SECONDS_PER_MINUTE
        return secondResult < 10 ? "0\(secondResult)" : "\(secondResult)"
    }
    
    static func getCurrentTime() -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)
        return "\(hour):\(minute)"
    }
}
