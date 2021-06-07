//
//  MusicControlBar.swift
//  one
//
//  Created by sidney on 2021/6/6.
//

import Foundation
import UIKit

class MusicControlBar: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var posterImageView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var musicAuthorLabel: UILabel!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var showListButton: UIButton!
    @IBOutlet weak var posterImageBkgViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var playButton: UIButton!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(musicInfo: Music) {
        self.musicNameLabel.text = musicInfo.name
        self.musicAuthorLabel.text = musicInfo.author
        if let url = URL(string: musicInfo.poster) {
            posterImage.loadFrom(url: url, isCircle: true, contentMode: .scaleAspectFill)
        }
        self.posterImageView.layer.cornerRadius = self.posterImageBkgViewWidth.constant / 2
        self.playButton.addTarget(self, action: #selector(playOrPauseMusic), for: .touchUpInside)
    }
    
    @objc func playOrPauseMusic() {
        let newPlayingStatus = !MusicService.shared.isPlaying
        MusicService.shared.isPlaying = newPlayingStatus
        playButton.setImage(UIImage(systemName: "\(newPlayingStatus ? "pause.fill" : "play.fill")"), for: .normal)
        if newPlayingStatus {
            MusicService.shared.play()
        } else {
            MusicService.shared.pause()
        }
    }
}
