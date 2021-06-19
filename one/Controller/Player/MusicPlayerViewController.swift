//
//  MusicPlayerViewController.swift
//  one
//
//  Created by sidney on 2021/6/19.
//

import UIKit
import MarqueeLabel

class MusicPlayerViewController: BaseViewController {
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var bkgImageView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var musicInfoViewInNavBar: UIView!
    @IBOutlet weak var musicNameLabel: MarqueeLabel!
    @IBOutlet weak var musicAuthorLabel: MarqueeLabel!
    @IBOutlet weak var soundBar: UIView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var controlBar: UIView!
    @IBOutlet weak var centerBkgView: UIView!
    @IBOutlet weak var centerOuterCircleView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var loopBtn: UIButton!
    @IBOutlet weak var lastBtn: UIButton!
    @IBOutlet weak var playBtnView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    
    let musicInstance = MusicService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.visualEffectView.effect = UIBlurEffect(style: ThemeManager.shared.getBlurStyle())
        self.playBtnView.layer.borderWidth = 1
        self.playBtnView.layer.borderColor = UIColor.white.cgColor
        self.playBtnView.setCircleCornerRadius()
        self.centerOuterCircleView.setCircleCornerRadius()
        AnimationUtils.addRotate(layer: posterImageView.layer)
        self.musicChange()
        NotificationService.shared.listenMusicStatus(target: self, selector: #selector(musicStatusChange))
        NotificationService.shared.listenMusicChange(target: self, selector: #selector(musicChange))
    }


    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func musicStatusChange() {
        if self.musicInstance.isPlaying {
            AnimationUtils.resumeRotate(layer: posterImageView.layer)
        } else {
            AnimationUtils.pauseRotate(layer: posterImageView.layer)
        }
    }
    
    @objc func musicChange() {
        let currentMusic = musicInstance.getCurrentMusic()
        self.musicNameLabel.text = currentMusic.name
        self.musicAuthorLabel.text = currentMusic.author
        if let url = URL(string: currentMusic.poster) {
            self.bkgImageView.sd_setImage(with: url, completed: nil)
            self.posterImageView.sd_setImage(with: url, completed: nil)
            self.posterImageView.setCircleCornerRadius()
        }
        self.playBtn.setImage(UIImage(systemName: "\(musicInstance.isPlaying ? "pause.fill" : "play.fill")"), for: .normal)
        AnimationUtils.resetRotate(layer: posterImageView.layer)
        self.musicStatusChange()
    }
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func share(_ sender: UIButton) {
    }
    
    @IBAction func mute(_ sender: UIButton) {
    }
    
    @IBAction func airPlay(_ sender: UIButton) {
    }
    
    @IBAction func loop(_ sender: UIButton) {
    }
    
    @IBAction func last(_ sender: UIButton) {
        self.musicInstance.last()
    }
    
    @IBAction func playOrPause(_ sender: UIButton) {
        let newPlayingStatus = !self.musicInstance.isPlaying
        self.playBtn.setImage(UIImage(systemName: "\(newPlayingStatus ? "pause.fill" : "play.fill")"), for: .normal)
        if newPlayingStatus {
            self.musicInstance.play()
        } else {
            self.musicInstance.pause()
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        self.musicInstance.next()
    }
    
    @IBAction func more(_ sender: UIButton) {
    }
}
