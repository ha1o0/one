//
//  MusicList.swift
//  one
//
//  Created by sidney on 2021/6/1.
//

import Foundation
import UIKit

class MusicListView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var name: UILabel = {
        let _name = UILabel()
        _name.textColor = .black
        _name.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return _name
    }()
    
    lazy var header: UIView = {
        let _header = UIView()
        _header.backgroundColor = .clear
        return _header
    }()
    
    lazy var collectionView: UICollectionView = {
        let _collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        // 必须设置为快速，否则滚动定位会非常慢
        _collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        _collectionView.backgroundColor = .clear
        return _collectionView
    }()
    
    var collectionLayout: MusicListCollectionViewLayout = {
        let layout = MusicListCollectionViewLayout()
        return layout
    }()
    
    var musics: [Music] = []
    var rowsPerColumn = 3
    var headerName = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakefromnib")
    }
    
    convenience init(musics: [Music] = [], headerName: String = "") {
        self.init()
        print("convenience musiclistview")
        self.musics = musics
        self.headerName = headerName
        // 补偿不足collectionview宽度整数倍的部分，3为单列的item行数, 20为collectionview与屏幕宽度的差值
        let subWidth = SCREEN_WIDTH - 20 - collectionLayout.itemSize.width
        print("subwidth: \(subWidth)")
        let rightInset = (ceil(CGFloat(musics.count / 3)) - 1) * subWidth
        self.collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightInset)
        self.commonInit()
    }
    
    func commonInit() {
        self.addSubview(header)
        header.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
            maker.height.equalTo(30)
        }
        
        name.text = self.headerName
        header.addSubview(name)
        name.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview().offset(5)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview().offset(0)
            maker.trailing.equalToSuperview().offset(0)
            maker.top.equalTo(header.snp.bottom)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
//        collectionView.isPagingEnabled = true // 必须为false，否则flowLayout中重写targetContentOffset修改的contentOffset无效
        registerNibWithName("MusicListItemCollectionViewCell", collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MusicListItemCollectionViewCell", for: indexPath) as! MusicListItemCollectionViewCell
        let data = musics[indexPath.row]
        cell.setContent(data: data)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset.x / scrollView.frame.width
//        print(offset)x
//        collectionView.contentOffset = CGPoint(x: (SCREEN_WIDTH - 50) * ceil(offset), y: 0)
    }
}
