//
//  MusicService.swift
//  one
//
//  Created by sidney on 2021/6/6.
//

import Foundation
import UIKit
import AVKit
import MediaPlayer

enum mediaDownloadStatus: String {
    case notDownload = "notDownload"
    case downloading = "downloading"
    case downloaded = "downloaded"
}

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
    var systemVol: Float {
        get {
            let vol = AVAudioSession.sharedInstance().outputVolume
            return vol
        }
    }
    var musicIndexList: [Int] = []
    var musicPlayProgressTimer: Timer!
    var isListenRemoteControl: Bool = false
    var imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var playTarget: Any? = nil
    var pauseTarget: Any? = nil
    var nextTarget: Any? = nil
    var lastTarget: Any? = nil
    var seekTarget: Any? = nil
    
    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        addRemoteTransportControls()
    }
    
    func listenVolumeButton(target: Any) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true, options: [])
            audioSession.addObserver(target as! NSObject, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
        } catch {
            print("Error")
        }
     }
    
    func play(atTime: TimeInterval = 0) {
        let isPlaying = self.isPlaying
        let currentMusic: Music = musicList[musicIndexList[currentMusicIndex]]
        let isMusicChanged: Bool = currentMusic.id != lastPlayingMusic.id
        guard let url: URL = getMusicUrl(urlStr: currentMusic.url, isLocal: currentMusic.isLocal, ofType: currentMusic.type) else {
            return
        }
        if self.playerItem != nil {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        }
        if isMusicChanged {
            playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
        }
        addRemoteTransportControls()
        self.setupNowPlaying()
        NotificationCenter.default.addObserver(self, selector: #selector(playToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        if atTime > 0 {
            player.seek(to: CMTimeMake(value: Int64(atTime), timescale: 1))
        }
        player.play()
        
        lastPlayingMusic = currentMusic
        if !isPlaying {
            NotificationService.shared.musicStatus(true)
        }
        if (TimerManager.shared.getTimer(timerName: .musicPlayProgress) != nil) {
            return
        }
        self.musicPlayProgressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
            NotificationService.shared.musicProgress()
            self.updateNowPlaying()
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
        let downloadStatus = self.getCurrentMusicDownloadStatus()
        if downloadStatus == .downloaded {
            if isLocal {
                if let bundlePath = Bundle.main.path(forResource: urlStr, ofType: ofType) {
                    url = URL(fileURLWithPath: bundlePath)
                }
            } else {
                url = FileDownloader.getFileUrl(originUrlStr: urlStr)
            }
        } else {
            if let urlPath = URL(string: urlStr) {
                url = urlPath
            }
        }
        return url
    }
    
    func getCurrentMusicDownloadStatus() -> mediaDownloadStatus {
        let music = self.getCurrentMusic()
        let localUrl = Storage.mediaCache[music.url] ?? ""
        var status: mediaDownloadStatus = .notDownload
        if localUrl == "downloading" {
            status = .downloading
        } else {
            if music.isLocal || localUrl != "" {
                status = .downloaded
            }
        }
        return status
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

extension MusicService {
    
    @objc func handleInterruption(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        switch type {
        case .began:
            self.pause()
            break
        case .ended:
//            self.playMusic(isSame: true)
            break
        default: ()
        }
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        playTarget = commandCenter.playCommand.addTarget { [unowned self] event in
            if !self.isPlaying {
                self.play()
                self.updateNowPlaying()
                return .success
            }

            return .commandFailed
        }

        // Add handler for Pause Command
        pauseTarget = commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.isPlaying {
                self.pause()
                self.updateNowPlaying()
                return .success
            }
            
            return .commandFailed
        }
        
        lastTarget = commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            if self.musicList.count > 0 {
                self.last()
                self.updateNowPlaying()
                return .success
            }
            return .commandFailed
        }
        
        nextTarget = commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            if self.musicList.count > 0 {
                self.next()
                self.updateNowPlaying()
                return .success
            }
            return .commandFailed
        }
        
        seekTarget = commandCenter.changePlaybackPositionCommand.addTarget { [unowned self] event in
            let positionEvent = event as! MPChangePlaybackPositionCommandEvent
            let currentPosition = Double(positionEvent.positionTime)
            let isPause = !self.isPlaying
            self.seekTo(second: currentPosition)
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentPosition
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1
            if isPause {
                self.play()
            }
            return .success
            
        }
    }
    
    func removeRemoteTransportControls() {
        if !isListenRemoteControl {
            return
        }
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.removeTarget(playTarget)
        playTarget = nil
        commandCenter.pauseCommand.removeTarget(pauseTarget)
        pauseTarget = nil
        commandCenter.previousTrackCommand.removeTarget(lastTarget)
        lastTarget = nil
        commandCenter.nextTrackCommand.removeTarget(nextTarget)
        nextTarget = nil
        commandCenter.changePlaybackPositionCommand.removeTarget(seekTarget)
        seekTarget = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
        isListenRemoteControl = false
    }
    
    func addRemoteTransportControls() {
        if isListenRemoteControl {
            return
        }
        setupRemoteTransportControls()
        isListenRemoteControl = true
    }
    
    func setupNowPlaying() {
        // Set the metadata
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.getCurrentMusic().name
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Float(self.currentPlayTime)
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = Float(self.totalPlayTime)
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        self.updateNowPlayingImage()
    }
    
    func updateNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Float(self.currentPlayTime)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = Float(self.totalPlayTime)
        if MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] == nil {
            self.updateNowPlayingImage()
        }
    }
    
    func updateNowPlayingImage() {
        imageView.sd_setImage(with: URL(string: self.getCurrentMusic().poster)) { (image, error, cacheType, url) in
            if let image = self.imageView.image {
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] =
                    MPMediaItemArtwork(boundsSize: image.size) { size in
                        return image
                }
            }
        }
    }
}
