//
//  MusicPlayerViewController.swift
//  one
//
//  Created by sidney on 2021/6/19.
//

import UIKit
import MarqueeLabel
import MediaPlayer

class MusicPlayerViewController: BaseViewController, ProgressBarDelegate {
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var bkgImageView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var musicInfoViewInNavBar: UIView!
    @IBOutlet weak var soundBar: UIView!
    @IBOutlet weak var soundBarContainerView: UIView!
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
    var systemVolumeView = MPVolumeView()
    
    lazy var musicNameLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var musicAuthorLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var musicProgressBar: ProgressBar = {
        let progressBar = ProgressBar(width: 0, currentCount: 0, totalCount: 0, showTimeLabel: true)
        progressBar.backgroundColor = .clear
        return progressBar
    }()
    
    lazy var musicSoundBar: ProgressBar = {
        let progressBar = ProgressBar(width: 0, currentCount: 0, totalCount: 1, showTimeLabel: false)
        progressBar.backgroundColor = .clear
        return progressBar
    }()
    
    let musicInstance = MusicService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMPVolumeView()
        self.progressBarView.addSubview(self.musicProgressBar)
        self.musicProgressBar.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.height.equalTo(30)
            maker.leading.equalToSuperview().offset(30)
            maker.trailing.equalToSuperview().offset(-30)
        }
        self.soundBarContainerView.addSubview(self.musicSoundBar)
        self.musicSoundBar.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.height.equalTo(30)
            maker.leading.equalToSuperview().offset(0)
            maker.trailing.equalToSuperview().offset(0)
        }
//        self.visualEffectView.effect = UIBlurEffect(style: ThemeManager.shared.getBlurStyle())
        self.musicInfoViewInNavBar.addSubview(musicNameLabel)
        musicNameLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
            maker.top.equalToSuperview().offset(5)
        }
        self.musicInfoViewInNavBar.addSubview(musicAuthorLabel)
        musicAuthorLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-3)
            maker.leading.trailing.equalToSuperview()
        }
        self.playBtnView.layer.borderWidth = 1
        self.playBtnView.layer.borderColor = UIColor.white.cgColor
        self.playBtnView.setCircleCornerRadius()
        self.centerOuterCircleView.setCircleCornerRadius()
        AnimationUtils.addRotate(layer: posterImageView.layer)
        self.view.layer.cornerRadius = hasNotch ? 20 : 0
        self.view.clipsToBounds = true
        self.musicChange()
        self.musicProgressBar.delegate = self
        self.musicProgressBar.updateView(currentCount: 0, totalCount: musicInstance.getCurrentMusic().duration)
        NotificationService.shared.listenMusicStatus(target: self, selector: #selector(musicStatusChange))
        NotificationService.shared.listenMusicChange(target: self, selector: #selector(musicChange))
        NotificationService.shared.listenMusicProgress(target: self, selector: #selector(musicProgress))
    }

    func initMPVolumeView() {
        systemVolumeView.frame.size = CGSize(width: 200, height: 1)
        systemVolumeView.center = self.view.center
        systemVolumeView.isHidden = true
        self.view.addSubview(systemVolumeView)
        musicSoundBar.changeValueCallback = self.setSystemVolumeValue
        musicSoundBar.updateView(currentCount: musicInstance.systemVol, totalCount: 1)
    }

    private func getSystemVolumSlider() -> UISlider {
        var volumViewSlider = UISlider()
        for subView in systemVolumeView.subviews {
            if type(of: subView).description() == "MPVolumeSlider" {
                volumViewSlider = subView as! UISlider
                return volumViewSlider
            }
        }
        return volumViewSlider
    }

    //获取系统音量大小
    private func getSystemVolumValue() -> Float {
        return getSystemVolumSlider().value

    }

    //调节系统音量大小
    private func setSystemVolumeValue(_ value: Float) {
        self.getSystemVolumSlider().value = value
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func musicStatusChange() {
        self.updatePlayBtn()
        if self.musicInstance.isPlaying {
            AnimationUtils.resumeRotate(layer: posterImageView.layer)
        } else {
            AnimationUtils.pauseRotate(layer: posterImageView.layer)
        }
    }
    
    @objc func musicChange(needResetAnimation: Bool = true) {
        let currentMusic = musicInstance.getCurrentMusic()
        self.musicNameLabel.text = currentMusic.name
        self.musicAuthorLabel.text = currentMusic.author
        if let url = URL(string: currentMusic.poster) {
            self.bkgImageView.sd_setImage(with: url, completed: nil)
            self.posterImageView.sd_setImage(with: url, completed: nil)
            self.posterImageView.setCircleCornerRadius()
        }
        self.updatePlayBtn()
        if needResetAnimation {
            AnimationUtils.resetRotate(layer: posterImageView.layer)
        }
        self.musicStatusChange()
    }
    
    @objc func musicProgress() {
        self.musicProgressBar.updateView(currentCount: Float(musicInstance.currentPlayTime), totalCount: Float(musicInstance.totalPlayTime))
    }
    
    func updatePlayBtn() {
        self.playBtn.setImage(UIImage(systemName: "\(musicInstance.isPlaying ? "pause.fill" : "play.fill")"), for: .normal)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        appDelegate.musicWindow?.hide()
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
    
    func changeSliderValue(value: Float) {
        self.musicInstance.seekTo(second: Double(value))
        AnimationUtils.resumeRotate(layer: self.posterImageView.layer)
    }
    
    func startChangeSliderValue(value: Float) {
        
    }
}
