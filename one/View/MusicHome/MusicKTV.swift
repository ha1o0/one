//
//  MusicKTV.swift
//  one
//
//  Created by sidney on 6/4/21.
//

import Foundation
import UIKit

class MusicKTVView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    var musicKTVs: [MusicKTV] = []
    var headerName = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakefromnib")
    }
    
    convenience init(musicKTVs: [MusicKTV] = [], headerName: String = "") {
        self.init()
        print("convenience init")
        self.musicKTVs = musicKTVs
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
        collectionView.isPagingEnabled = false
        registerNibWithName("MusicKTVItemCollectionViewCell", collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicKTVs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MusicKTVItemCollectionViewCell", for: indexPath) as! MusicKTVItemCollectionViewCell
        cell.setContent(data: musicKTVs[indexPath.row])
        print("setCell: \(indexPath)")
        return cell
    }
}
