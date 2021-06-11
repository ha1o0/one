//
//  MusicHomeModel.swift
//  one
//
//  Created by sidney on 5/19/21.
//

import Foundation
import UIKit

enum MusicSection: String {
    case poster = "poster"
    case function = "function"
    case musicSheet = "musicSheet"
    case musicList = "musicList"
    case featureVideos = "featureVideos"
    case rank = "rank"
    case ktv = "ktv"
    case podcast = "podcast"
}

struct MusicHomeSection {
    var type: MusicSection = .poster
    var items: [Any] = []
    var title: String = ""
    
}

struct MusicHomeItem {
    var posters: [MusicPoster] = []
}

struct MusicPoster {
    var url: String = ""
    var color: UIColor = .white
}

struct MusicSheet {
    var name = ""
    var id = ""
    var posters: [String] = []
    var playCount = 0
}

struct Music {
    var id = ""
    var poster: String = ""
    var name: String = ""
    var subtitle: String = ""
    var playCount: Int = 0
    var author: String = ""
    var url: String = ""
    var isLocal: Bool = false
    var type: String = "mp3"
}

struct MusicFunction {
    var icon: String = ""
    var name: String = ""
    var to: String = ""
}

struct MusicKTV {
    var roomColors: [String] = [] // 渐变色号
    var roomId: String = ""
    var roomTitle: String = ""
    var currentMusicName: String = ""
    var currentImage: String = ""
    var roomUserNumber: Int = 0
}

struct Author {
    var id = ""
    var avatar = ""
    var name = ""
}

struct SimpleVideo {
    var id = ""
    var name = ""
    var title = ""
    var poster = ""
    var duration = 0
    var playCount = 0
    var likeCount = 0
    var author = Author()
    var url = ""
}
