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
        let minuteResult = seconds / SECONDS_PER_MINUTE
        return minuteResult < 10 ? "0\(minuteResult)" : "\(minuteResult)"
    }
    
    static func getTimeHoursBySeconds(_ seconds: Int) -> String {
        let minuteResult = seconds / SECONDS_PER_MINUTE
        let hourResult = minuteResult / MINUTES_PER_HOUR
        return hourResult < 10 ? "0\(hourResult)" : "\(hourResult)"
    }
    
    static func getTimeBySeconds(_ seconds: Int) -> String {
        var result = ""
        let minuteResult = seconds / SECONDS_PER_MINUTE
        if minuteResult < 60 {
            result = "\(self.getTimeMinutesBySeconds(seconds)):\(self.getTimeSecondBySeconds(seconds))"
        } else {
            let hourResult = self.getTimeHoursBySeconds(seconds)
            let restMinutes = minuteResult % MINUTES_PER_HOUR
            let restMinutesStr = restMinutes < 10 ? "0\(restMinutes)" : "\(restMinutes)"
            result = "\(hourResult):\(restMinutesStr):\(self.getTimeSecondBySeconds(seconds))"
        }
        return result
    }
    
    static func getCurrentTime() -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)
        return "\(hour):\(minute)"
    }
}
