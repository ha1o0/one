//
//  Carousel.swift
//  one
//
//  Created by sidney on 5/25/21.
//

import UIKit

class Carousel: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var collectionView: UICollectionView = {
        let _collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 120), collectionViewLayout: CollectionViewLayout())
        _collectionView.backgroundColor = .systemOrange
        return _collectionView
    }()
    var images: [MusicPoster] = []
    var doCallbackInvock = false
    var currentIndex = 0

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    convenience init(images: [MusicPoster] = []) {
        self.init()
        self.images = images
    }
    
    override func draw(_ rect: CGRect) {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        registerNibWithName("CarouselCollectionViewCell", collectionView: collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCollectionViewCell", for: indexPath) as! CarouselCollectionViewCell
        cell.setContent(data: images[indexPath.row])
        return cell
    }
    
    
    // MARK: delegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let contentOffset = scrollView.contentOffset
//        print("\(contentOffset)")
//        setPage(index: Int(contentOffset.x / self.frame.width))
//        if contentOffset.x == 0 {
//            setPage(index: Int(contentOffset.x / self.frame.width))
//        } else if doCallbackInvock {
//            setPage(index: Int(contentOffset.x / self.frame.width))
//        }
//    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("animation")
        doCallbackInvock = true
        
    }
    
    func setPage(index: Int) {
        print("setpage")
        let point = CGPoint(x: CGFloat(index) * (collectionView.frame.size.width + 30), y: collectionView.frame.origin.y)
        doCallbackInvock = false
        collectionView.setContentOffset(point, animated: true)
        currentIndex = index
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        let contentOffset = scrollView.contentOffset
//        print("didend\(contentOffset)")
//        var willIndex = currentIndex
//        if contentOffset.x >= (collectionView.frame.width + 30) * CGFloat(currentIndex) {
//        }
//        setPage(index: Int(contentOffset.x / self.frame.width))
//    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView == self.collectionView {
//            var currentCellOffset = self.collectionView.contentOffset
//            currentCellOffset.x += self.collectionView.frame.width / 2
//            if let indexPath = self.collectionView.indexPathForItem(at: currentCellOffset) {
//              self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//            }
//        }
//    }
}
