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
    var currentPlayTime: TimeInterval { get }
    var totalPlayTime: TimeInterval { get }
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
    var currentPlayTime: TimeInterval {
        get {
            return playerItem.currentTime().seconds
        }
    }
    var totalPlayTime: TimeInterval {
        get {
            return playerItem.duration.seconds
        }
    }
    var musicList: [Music] = [] {
        didSet {
            currentMusicIndex = 0
            self.generateMusicIndexList()
        }
    }
    var musicIndexList: [Int] = []
    var musicPlayProgressTimer: Timer!
    
    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
    }
    
    func play(atTime: TimeInterval = 0) {
        let currentMusic: Music = musicList[musicIndexList[currentMusicIndex]]
        let isMusicChanged: Bool = currentMusic.id != lastPlayingMusic.id
        guard let url: URL = getMusicUrl(urlStr: currentMusic.url, isLocal: currentMusic.isLocal, ofType: currentMusic.type)
        else {
            return
        }
        if self.playerItem != nil {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        }
        if isMusicChanged {
            playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        if atTime > 0 {
            player.seek(to: CMTimeMake(value: Int64(atTime), timescale: 1))
            player.play()
        } else {
            player.play()
        }
        lastPlayingMusic = currentMusic
        NotificationService.shared.musicStatus(true)
        if (TimerManager.shared.getTimer(timerName: .musicPlayProgress) != nil) {
            return
        }
        self.musicPlayProgressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            NotificationService.shared.musicProgress()
        })
        TimerManager.shared.setTimer(timerName: .musicPlayProgress, timer: self.musicPlayProgressTimer)
    }
    
    func pause() {
        guard let player = player else {
            return
        }
        player.pause()
        NotificationService.shared.musicStatus(false)
        TimerManager.shared.invalidateTimer(timerName: .musicPlayProgress)
        TimerManager.shared.deleteTimer(timerName: .musicPlayProgress)
    }
    
    func seekTo(second: Double) {
        self.play(atTime: TimeInterval(second))
    }
    
    func next() {
        self.pause()
        let nextIndex = self.currentMusicIndex + 1
        self.currentMusicIndex = nextIndex >= self.musicIndexList.count ? 0 : nextIndex
        self.play()
        NotificationService.shared.musicChange()
    }
    
    func last() {
        self.pause()
        let lastIndex = self.currentMusicIndex - 1
        self.currentMusicIndex = lastIndex <= -1 ? (self.musicIndexList.count - 1) : lastIndex
        self.play()
        NotificationService.shared.musicChange()
    }
    
    func stop() {
        guard let player = player else {
            return
        }
        player.seek(to: CMTime.zero)
    }
    
    @objc func playToEnd() {
        self.player.seek(to: CMTime.zero)
        self.play()
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
    
    func getCurrentMusic() -> Music {
        let music = self.musicList[self.musicIndexList[self.currentMusicIndex]]
        return music
    }
}
