//
//  TabBarMusicCollectionViewCell.swift
//  one
//
//  Created by sidney on 6/7/21.
//

import UIKit

class TabBarMusicCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var posterOuterView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var musicAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.posterOuterView.layer.cornerRadius = self.posterOuterView.bounds.width / 2
        AnimationUtils.addRotate(layer: posterImageView.layer)
    }

    func setContent(data: Music) {
        self.musicNameLabel.text = data.name
        self.musicAuthorLabel.text = data.author
        if let url = URL(string: data.poster) {
            posterImageView.loadFrom(url: url, isCircle: true, contentMode: .scaleAspectFill)
            AnimationUtils.resetRotate(layer: posterImageView.layer)
        }
        NotificationService.shared.removeNotification(target: self)
        NotificationService.shared.listenMusicStatus(target: self, selector: #selector(musicStatusChange))
        NotificationService.shared.listenMusicChange(target: self, selector: #selector(musicChange))
    }
    
    @objc func musicStatusChange() {
        print("tabbar musicStatusChange")
        if MusicService.shared.isPlaying {
            AnimationUtils.resumeRotate(layer: posterImageView.layer)
        } else {
            AnimationUtils.pauseRotate(layer: posterImageView.layer)
        }
    }
    
    @objc func musicChange() {
        print("tabbar musicchange")
        let currentMusic = MusicService.shared.getCurrentMusic()
        self.musicNameLabel.text = currentMusic.name
        self.musicAuthorLabel.text = currentMusic.author
        if let url = URL(string: currentMusic.poster) {
            posterImageView.loadFrom(url: url, isCircle: true, contentMode: .scaleAspectFill)
        }
        AnimationUtils.resetRotate(layer: posterImageView.layer)
        if MusicService.shared.isPlaying {
            delay(0) {
                AnimationUtils.resumeRotate(layer: self.posterImageView.layer)
            }
        }
    }
}
