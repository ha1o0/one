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
    var enableScroll: Bool = false
    var linespacing: CGFloat = 0
}

protocol SwitchTabDelegate: AnyObject {
    func switchTabTo(index: Int)
}

class SwitchTabView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SwitchTabDelegate {
    var switchTab: SwitchTab = SwitchTab()
    var currentIndex = 0 {
        didSet {
            UIView.performWithoutAnimation {
                self.collectionView.reloadData()
            }
        }
    }

    var collectionView: UICollectionView!
    
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
        let layout = UICollectionViewFlowLayout()
        print(self.switchTab.linespacing)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let spacing = self.switchTab.linespacing / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
//        collectionView.isScrollEnabled = self.switchTab.enableScroll
        registerNibWithName("SwitchTabCollectionViewCell", collectionView: collectionView)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return switchTab.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchTabCollectionViewCell", for: indexPath) as! SwitchTabCollectionViewCell
        cell.delegate = self
        cell.setContent(data: self.switchTab, index: indexPath.section, selectedIndex: currentIndex)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = self.switchTab.titles[indexPath.section]
        print(title)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: self.switchTab.titleSelectedSize)]
        let width = (title.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: STATUS_NAV_HEIGHT - STATUS_BAR_HEIGHT), options: NSStringDrawingOptions.usesFontLeading, attributes: attributes, context: nil).size.width) + 15
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    @objc func switchTabTo(index: Int) {
        print(index)
        self.currentIndex = index
    }
    
}
