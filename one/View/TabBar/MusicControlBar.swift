//
//  MusicControlBar.swift
//  one
//
//  Created by sidney on 2021/6/6.
//

import Foundation
import UIKit

class MusicControlBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
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
    @IBOutlet weak var collectionBkgView: UIView!
    @IBOutlet weak var playButton: UIButton!
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
