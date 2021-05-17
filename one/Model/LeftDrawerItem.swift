//
//  LeftDrawerItem.swift
//  one
//
//  Created by sidney on 5/17/21.
//

import Foundation

struct LeftDrawerSection {
    var items: [LeftDrawerItem] = []
    var title: String = ""
}

struct LeftDrawerItem {
    var name: String = ""
    var iconName: String = ""
    var hasSwitch: Bool = false
    var subInfo: String = ""
}
