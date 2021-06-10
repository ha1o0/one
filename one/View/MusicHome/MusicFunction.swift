//
//  MusicFunction.swift
//  one
//
//  Created by sidney on 2021/5/27.
//

import Foundation
import UIKit

class MusicFunctionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var collectionView: UICollectionView = {
        let layout = CollectionViewLayout()
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 60, height: 68)
        let _collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        _collectionView.backgroundColor = .clear
        return _collectionView
    }()
    
    var functions: [MusicFunction] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    convenience init(functions: [MusicFunction] = []) {
        self.init()
        self.functions = functions
        self.commonInit()
    }
    
    func commonInit() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        registerNibWithName("FunctionCollectionViewCell", collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return functions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "FunctionCollectionViewCell", for: indexPath) as! FunctionCollectionViewCell
        cell.setContent(data: functions[indexPath.row])
        return cell
    }
}
