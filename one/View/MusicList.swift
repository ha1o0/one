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
        _name.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return _name
    }()
    
    lazy var header: UIView = {
        let _header = UIView()
        _header.backgroundColor = .clear
        return _header
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = CollectionViewLayout()
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: SCREEN_WIDTH - 20, height: 70)
        layout.scrollDirection = .horizontal
        let _collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        _collectionView.backgroundColor = .clear
        return _collectionView
    }()
    
    var musics: [Music] = []
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
        collectionView.isPagingEnabled = true
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
        let offset = scrollView.contentOffset.x / scrollView.frame.width
        print(offset)
    }
}
