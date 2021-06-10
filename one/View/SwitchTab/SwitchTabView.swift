//
//  SwitchTabView.swift
//  one
//
//  Created by sidney on 6/10/21.
//

import Foundation
import UIKit

struct SwitchTab {
    var titles: [String] = []
    var hasBottomLine:Bool = true
    var titleSelectedColor: UIColor = UIColor.main
    var titleColor: UIColor = UIColor.gray
    var titleSize: CGFloat = 15.0
    var titleSelectedSize: CGFloat = 15.0
}

protocol SwitchTabDelegate: AnyObject {
    func switchTabTo(index: Int)
}

class SwitchTabView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, SwitchTabDelegate {
    var switchTab: SwitchTab = SwitchTab()
    var currentIndex = 0

    var collectionView: UICollectionView = {
        let _collectionView = UICollectionView()
        let _layout = SwitchTabCollectionLayout()
        _collectionView.collectionViewLayout = _layout
        _collectionView.backgroundColor = .clear
        return _collectionView
    }()
    
    var underLineView = UIView()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    convenience init(switchTab: SwitchTab) {
        self.init()
        self.switchTab = switchTab
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = .clear
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        registerNibWithName("SwitchTabCollectionViewCell", collectionView: collectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return switchTab.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchTabCollectionViewCell", for: indexPath) as! SwitchTabCollectionViewCell
        cell.setContent(data: self.switchTab, index: indexPath.row, selectedIndex: currentIndex)

        return cell
    }
    
    func switchTabTo(index: Int) {
        print(index)
    }
    
}
