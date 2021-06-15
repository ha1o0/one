//
//  LiveListView.swift
//  diyplayer
//
//  Created by sidney on 2020/4/6.
//  Copyright © 2020 sidney. All rights reserved.
//

import UIKit
import SnapKit

class LiveListView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, SwitchTabDelegate {

    private var collectionView: UICollectionView?
    private var pageViewList: [UIView]?
    private var callback : ((_ offset: CGFloat) -> ())?
    private var currentIndex: Int?
    private var isScrollingLock: Bool = false
    private var switchTabView: SwitchTabView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, pageViewList: [UIView], switchTabView: SwitchTabView, callback: @escaping (_ offset: CGFloat) -> ()) {
        self.init(frame: frame)
        self.callback = callback
        self.pageViewList = pageViewList
        self.switchTabView = switchTabView
        self.switchTabView?.delegate = self
        let collectionLayout = UICollectionViewFlowLayout()
        print(frame.size)
        collectionLayout.itemSize = frame.size
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collectionView = UICollectionView.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size), collectionViewLayout: collectionLayout)
        collectionView?.backgroundColor = .clear
        collectionView?.isPagingEnabled = true
        addSubview(collectionView!)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.showsHorizontalScrollIndicator = true
        collectionView?.showsVerticalScrollIndicator = true
        for index in 0...pageViewList.count {
            collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "\(index)")
        }
    }
    
    // MARK: dataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let count  = self.pageViewList?.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(indexPath.section)", for: indexPath)
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        if let view = self.pageViewList?[indexPath.section] {
            scrollView.addSubview(view)
//            print("contentsize: \(view.bounds)")
            scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        }
        cell.contentView.addSubview(scrollView)
        return cell
    }
    
    // MARK: delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let contentOffset = collectionView?.contentOffset {
            let offset = contentOffset.x / self.frame.width
            callback?(offset)
            self.switchTabView?.scrollOffset(offset: offset)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrollingLock = false
        self.switchTabView?.switchTabTo(index: Int(scrollView.contentOffset.x / self.frame.width), fromClick: false)
        print("scrollViewDidEndDecelerating: \(isScrollingLock)")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrollingLock = false
        print("scrollViewDidEndScrollingAnimation: \(isScrollingLock)")
    }
    
    func switchTabTo(index: Int, fromClick: Bool) {
        print("执行vc滚动\(isScrollingLock)")
        if isScrollingLock {
            return
        }
        isScrollingLock = true
        print("执行delegate即将滚到：\(index)")
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: index), at: .centeredHorizontally, animated: true)
    }

}
