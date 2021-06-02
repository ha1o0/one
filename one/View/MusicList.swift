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
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: 100, height: 150)
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
        name.text = self.headerName
        header.addSubview(name)
        name.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(5)
        }
        self.addSubview(header)
        header.snp.makeConstraints { maker in
            maker.leading.top.trailing.equalToSuperview()
            maker.height.equalTo(35)
        }
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.top.equalTo(header.snp.bottom)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        registerNibWithName("MusicListCollectionViewCell", collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(ceil(Double(musics.count / 3)))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MusicListCollectionViewCell", for: indexPath) as! MusicListCollectionViewCell
        var currentMusics: [Music] = []
        for (index, music) in musics.enumerated() {
            if index % collectionView.numberOfItems(inSection: 0) == indexPath.row {
                currentMusics.append(music)
            }
        }
        print(currentMusics)
        cell.setContent(data: currentMusics)
        return cell
    }
}
