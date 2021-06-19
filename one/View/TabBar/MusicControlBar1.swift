//
//  MusicControlBar1.swift
//  one
//
//  Created by sidney on 2021/6/9.
//

import Foundation
import UIKit

class MusicControlBar1: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var visualEffectView: UIView!
    @IBOutlet weak var collectionBkgView: UIView!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var showListButton: UIButton!
    @IBOutlet weak var collectionBkgViewHeightConstraints: NSLayoutConstraint!
    var collectionViewWidth: CGFloat = SCREEN_WIDTH - 150
    var pageCallback: ((Int) -> Void)?
    var currentIndex: Int = 0 {
        didSet {
            if let callback = self.pageCallback {
                callback(currentIndex)
            }
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = CollectionViewLayout()
        layout.itemSize = CGSize(width: collectionViewWidth, height: collectionBkgViewHeightConstraints.constant)
        let _collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        _collectionView.backgroundColor = .clear
        return _collectionView
    }()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func commonInit() {
        self.visualEffectView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.05)
        collectionBkgView.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.width.equalTo(collectionViewWidth)
            maker.height.equalTo(collectionBkgViewHeightConstraints.constant)
            maker.center.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        registerNibWithName("TabBarMusicCollectionViewCell", collectionView: collectionView)
        self.playButton.addTarget(self, action: #selector(playOrPauseMusic), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openMusicVc))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        NotificationService.shared.listenMusicStatus(target: self, selector: #selector(musicStatusChange))
        NotificationService.shared.listenMusicChange(target: self, selector: #selector(musicChange))
    }
    
    @objc func musicStatusChange() {
        playButton.setImage(UIImage(systemName: "\(MusicService.shared.isPlaying ? "pause.fill" : "play.fill")"), for: .normal)
    }
    
    @objc func musicChange() {
        self.collectionView.scrollToItem(at: IndexPath(row: MusicService.shared.currentMusicIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @objc func openMusicVc() {
        let topVc = getTopViewController()
        topVc?.pushVc(vc: MusicPlayerViewController(), animate: true, hideAll: true)
    }
    
    @objc func playOrPauseMusic() {
        let newPlayingStatus = !MusicService.shared.isPlaying
        playButton.setImage(UIImage(systemName: "\(newPlayingStatus ? "pause.fill" : "play.fill")"), for: .normal)
        if newPlayingStatus {
            MusicService.shared.play()
        } else {
            MusicService.shared.pause()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "TabBarMusicCollectionViewCell", for: indexPath) as! TabBarMusicCollectionViewCell
        cell.setContent(data: MusicService.shared.musicList[MusicService.shared.musicIndexList[indexPath.row]])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MusicService.shared.musicList.count
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.updateCurrentIndexAfterScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateCurrentIndexAfterScroll(scrollView)
    }
    
    func updateCurrentIndexAfterScroll(_ scrollView: UIScrollView) {
        let newIndex = Int(scrollView.contentOffset.x / self.collectionView.frame.width)
        if newIndex == currentIndex {
            return
        }
        currentIndex = newIndex
        MusicService.shared.pause()
        MusicService.shared.currentMusicIndex = currentIndex
        self.playOrPauseMusic()
    }
}
