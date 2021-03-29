//
//  LiveListView.swift
//  diyplayer
//
//  Created by sidney on 2020/4/6.
//  Copyright © 2020 sidney. All rights reserved.
//

import UIKit
import SnapKit

class LiveListView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView?
    private var pageViewList: [UIView]?
    private var callback : ((_ offset: CGFloat) -> ())?
    private var currentIndex: Int?
    private var doCallbackInvock: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, pageViewList: [UIView], callback: @escaping (_ offset: CGFloat) -> ()) {
        self.init(frame: frame)
        self.callback = callback
        self.pageViewList = pageViewList
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.itemSize = frame.size
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collectionView = UICollectionView.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size), collectionViewLayout: collectionLayout)
        collectionView?.backgroundColor = UIColor.blue
        collectionView?.isPagingEnabled = true
        addSubview(collectionView!)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.showsHorizontalScrollIndicator = true
        collectionView?.showsVerticalScrollIndicator = true
        if (pageViewList.count > 0) {
            for index in 0...pageViewList.count {
                collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "\(index)")
            }
        }
        
    }
    
    // MARK: dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count  = self.pageViewList?.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(indexPath.row)", for: indexPath)
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        if let view = self.pageViewList?[indexPath.row] {
            scrollView.addSubview(view)
            scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        }
        cell.contentView.addSubview(scrollView)
        return cell
    }
    
    // MARK: delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let contentOffset = collectionView?.contentOffset {
            if contentOffset.x == 0 {
                callback?(0)
            } else if doCallbackInvock {
                callback?(contentOffset.x / self.frame.width)
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        doCallbackInvock = true
    }
    
    func setPage(index: Int) {
        let point = CGPoint(x: CGFloat(index) * collectionView!.frame.size.width, y: collectionView!.frame.origin.y)
        doCallbackInvock = false
        collectionView?.setContentOffset(point, animated: true)
        currentIndex = index
    }

}
