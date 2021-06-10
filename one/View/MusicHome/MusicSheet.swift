//
//  MusicSheet.swift
//  one
//
//  Created by sidney on 5/31/21.
//

import Foundation
import UIKit

class MusicSheetView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    var musicSheets: [MusicSheet] = []
    var headerName = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    convenience init(musicSheets: [MusicSheet] = [], headerName: String = "") {
        self.init()
        self.musicSheets = musicSheets
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
        registerNibWithName("MusicSheetCollectionViewCell", collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicSheets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MusicSheetCollectionViewCell", for: indexPath) as! MusicSheetCollectionViewCell
        cell.setContent(data: musicSheets[indexPath.row], indexPath: indexPath)
//        print("setCell: \(indexPath)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("enddisplay: \(indexPath)")
        let cellData = musicSheets[indexPath.row]
        if cellData.posters.count > 0 {
            // 不能在这里结束定时器
//            TimerManager.shared.invalidateTimer(timerName: .musicPosterLoop)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        print("willDisplay: \(indexPath)")
    }
}
