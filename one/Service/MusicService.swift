//
//  MusicService.swift
//  one
//
//  Created by sidney on 2021/6/6.
//

import Foundation
import UIKit
import AVKit

protocol MusicPlayer {
    var player: AVPlayer! { get set }
    var isPlaying: Bool { get }
    var currentMusicIndex: Int { get set }
    var musicList: [Music] { get set }
    var lastPlayingMusic: Music { get set }
    var musicIndexList: [Int] { get set }
    var currentPlayTime: TimeInterval { get set }
    func play(atTime: TimeInterval)
    func pause()
    func seekTo(second: Double)
    func stop()
}

class MusicService: MusicPlayer {
    static let shared = MusicService()
    var isPlaying: Bool {
        get {
            if (player == nil) {
                return false
            }
            return player.isPlaying
        }
    }
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var currentMusicIndex: Int = 0
    var lastPlayingMusic: Music = Music()
    var currentPlayTime: TimeInterval = 0
    var musicList: [Music] = [] {
        didSet {
            currentMusicIndex = 0
            self.generateMusicIndexList()
        }
    }
    var musicIndexList: [Int] = []
    
    private init() {}
    
    func play(atTime: TimeInterval = 0) {
        let currentMusic: Music = musicList[musicIndexList[currentMusicIndex]]
        let isMusicChanged: Bool = currentMusic.id != lastPlayingMusic.id
        guard let url: URL = getMusicUrl(urlStr: currentMusic.url, isLocal: currentMusic.isLocal, ofType: currentMusic.type)
        else {
            return
        }
        if isMusicChanged {
            playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
        }
        if atTime > 0 {
            player.seek(to: CMTimeMake(value: Int64(atTime), timescale: 1))
            player.play()
        } else {
            player.play()
        }
        lastPlayingMusic = currentMusic
        NotificationService.shared.musicStatus(true)
    }
    
    func pause() {
        guard let player = player else {
            return
        }
        player.pause()
        NotificationService.shared.musicStatus(false)
    }
    
    func seekTo(second: Double) {
        
    }
    
    func stop() {
        guard let player = player else {
            return
        }
        player.seek(to: CMTime.zero)
    }
    
    func getMusicUrl(urlStr: String, isLocal: Bool = false, ofType: String = "") -> URL? {
        var url: URL?
        if isLocal {
            if let bundlePath = Bundle.main.path(forResource: urlStr, ofType: ofType) {
                url = URL(fileURLWithPath: bundlePath)
            }
        } else {
            if let urlPath = URL(string: urlStr) {
                url = urlPath
            }
        }
        return url
    }
    
    func generateMusicIndexList() {
        self.musicIndexList = self.musicList.enumerated().map({ (index, music) in
            return index
        })
    }
}
