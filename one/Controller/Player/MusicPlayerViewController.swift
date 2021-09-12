//
//  MusicPlayerViewController.swift
//  one
//
//  Created by sidney on 2021/6/19.
//

import UIKit
import MarqueeLabel
import MediaPlayer

class MusicPlayerViewController: BaseViewController, ProgressBarDelegate, FileDownloadDelegate {
    
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var bkgImageView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var musicInfoViewInNavBar: UIView!
    @IBOutlet weak var soundBar: UIView!
    @IBOutlet weak var soundBarContainerView: UIView!
    @IBOutlet weak var optionBarView: UIView!
    @IBOutlet weak var isDownloadedImageView: UIImageView!
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
        let progressBar = ProgressBar(width: 0, currentCount: 0, totalCount: 1, isContinuous: true, showTimeLabel: false)
        progressBar.backgroundColor = UIColor.clear
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
        musicInstance.listenVolumeButton(target: self)
    }

    func listenVolumeButton() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true, options: [])
            audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
        } catch {
            print("Error")
        }
     }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume"{
            let audioSession = AVAudioSession.sharedInstance()
            self.musicSoundBar.updateView(currentCount: audioSession.outputVolume, totalCount: 1)
        }
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
        self.updateMusicInfo()
        self.updatePlayBtn()
        AnimationUtils.resetRotate(layer: posterImageView.layer)
        if musicInstance.isPlaying {
            delay(0) {
                AnimationUtils.resumeRotate(layer: self.posterImageView.layer)
            }
        }
    }
    
    @objc func musicProgress() {
        self.musicProgressBar.updateView(currentCount: Float(musicInstance.currentPlayTime), totalCount: Float(musicInstance.totalPlayTime))
    }
    
    func updateMusicInfo() {
        let currentMusic = musicInstance.getCurrentMusic()
        self.musicNameLabel.text = currentMusic.name
        self.musicAuthorLabel.text = currentMusic.author
        if let url = URL(string: currentMusic.poster) {
            self.bkgImageView.sd_setImage(with: url, completed: nil)
            self.posterImageView.sd_setImage(with: url, completed: nil)
            self.posterImageView.setCircleCornerRadius()
        }
        self.isDownloadedImageView.isHidden = MusicService.shared.getCurrentMusicDownloadStatus() != .downloaded
    }
    
    func updatePlayBtn() {
        self.playBtn.setImage(UIImage(systemName: "\(musicInstance.isPlaying ? "pause.fill" : "play.fill")"), for: .normal)
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        appDelegate.musicWindow?.hide()
    }
    
    @IBAction func download(_ sender: UIButton) {
        let music = MusicService.shared.getCurrentMusic()
//        Storage.mediaCache[music.url] = ""
        let status = MusicService.shared.getCurrentMusicDownloadStatus()
        if status == .downloaded {
            if music.isLocal {
                self.view.makeToast("歌曲已下载, Bundle资源不能删除")
                return
            } else {
                self.willDeleteFileAlert(music.url)
            }
            return
        } else if status == .downloading {
            self.view.makeToast("歌曲正在下载")
            return
        }
        let downloader = FileDownloader()
        downloader.download(urlStr: music.url, delegate: self)
        self.view.makeToast("歌曲开始下载")
    }
    
    @IBAction func share(_ sender: UIButton) {
        let currentMusic = MusicService.shared.getCurrentMusic()
        if (currentMusic.isLocal) {
            return
        }
        do {
            let currentMusicUrl: URL = FileDownloader.getFileUrl(originUrlStr: currentMusic.url)
            print(currentMusicUrl.absoluteString)
//            let data = try Data(contentsOf: currentMusicUrl)
            let objectsToShare = [currentMusicUrl] as [Any]
            let activityController = UIActivityViewController(
                    activityItems: objectsToShare,
                    applicationActivities: nil)

            activityController.popoverPresentationController?.sourceRect = view.frame
            activityController.popoverPresentationController?.sourceView = view
            activityController.popoverPresentationController?.permittedArrowDirections = .any
            present(activityController, animated: true, completion: nil)
        } catch let error {
            print(error)
        }
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
    }
    
    func startChangeSliderValue(value: Float) {
        
    }
    
    func willDeleteFileAlert(_ willDeleteFileUrl: String) {
        let alertVC = UIAlertController(title: "提示", message: "确定删除本地文件吗？", preferredStyle: UIAlertController.Style.alert)
        let acSure = UIAlertAction(title: "确定", style: UIAlertAction.Style.destructive) { (UIAlertAction) -> Void in
            let result = CacheManager.shared.deleteFile(willDeleteCacheKey: willDeleteFileUrl)
            if result {
                self.view.makeToast("删除成功")
                DispatchQueue.main.async {
                    self.updateMusicInfo()
                }
            }
        }
        let acCancel = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel) { (UIAlertAction) -> Void in }
        alertVC.addAction(acSure)
        alertVC.addAction(acCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func updateDownloadProgress(progress: Float, urlStr: String) {
        print("下载进度：\(progress)")
    }
    
    func downloadSuccess(location: URL, urlStr: String) {
        self.updateMusicInfo()
        self.view.makeToast("下载成功")
    }
    
    func downloadFail(error: Error, urlStr: String) {
        print("下载失败：\(urlStr)")
    }
}
