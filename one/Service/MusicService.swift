//
//  MusicService.swift
//  one
//
//  Created by sidney on 2021/6/6.
//

import Foundation
import UIKit

class MusicService {
    static let shared = MusicService()
    var isPlaying = false
    var currentMusic: Music?
    
    private init() {}
    
    
}
