//
//  WebService.swift
//  one
//
//  Created by sidney on 2021/12/18.
//

import Foundation

class WebService {
    static let shared = WebService()
    
    var blackList: [String] = []
    var whiteList: [String] = []

    private init() {
        self.blackList = [
            "https://www.google.com"
        ]
    }

    func isUrlInBlackList(url: String) -> Bool {
        for item in self.blackList {
            if url.contains(item) {
                return true
            }
        }
        return false
    }
}
