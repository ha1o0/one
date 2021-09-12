//
//  Date+Extension.swift
//  one
//
//  Created by sidney on 2021/9/12.
//

import Foundation

extension Date {
    var timeStamp: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return "\(Int(timeInterval))"
    }
    
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval * 1000))
        return "\(millisecond)"
    }
}
