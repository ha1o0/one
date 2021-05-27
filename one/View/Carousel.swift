//
//  Carousel.swift
//  one
//
//  Created by sidney on 5/25/21.
//

import UIKit

class Carousel: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var collectionView: UICollectionView = {
        let _collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayout())
        _collectionView.backgroundColor = .clear
        return _collectionView
    }()
    
    lazy var indicatorView: UIStackView = {
        let _indicatorView = UIStackView()
        return _indicatorView
    }()
    var images: [MusicPoster] = []
    var pageCallback: ((Int) -> Void)?
    var doCallbackInvock = false
    var currentIndex = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakefromnib")
    }
    
    convenience init(images: [MusicPoster] = []) {
        self.init()
        print("convenience init")
        self.images = images
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
        collectionView.isPagingEnabled = true
        registerNibWithName("CarouselCollectionViewCell", collectionView: collectionView)
        collectionView.layer.cornerRadius = 10
        collectionView.layer.masksToBounds = true
        
        indicatorView.backgroundColor = .clear
        indicatorView.alignment = .fill
        indicatorView.distribution = .fillEqually
        indicatorView.axis = .horizontal
        indicatorView.spacing = 5
        print(self.images)
        
        for (index, _) in self.images.enumerated() {
            let dotView = UIView()
            dotView.backgroundColor = index == currentIndex ? UIColor.white : UIColor.white.withAlphaComponent(0.6)
            dotView.layer.cornerRadius = 2
            indicatorView.addArrangedSubview(dotView)
        }
        indicatorView.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-20)
            maker.height.equalTo(3)
            maker.width.equalTo(self.images.count * 15 + (images.count - 1) * Int(indicatorView.spacing))
        }
    }
    
    override func draw(_ rect: CGRect) {
        print("draw rect")
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / self.frame.width)
        updateIndicator()
        if let callback = self.pageCallback {
            callback(currentIndex)
        }
    }
    
    func updateIndicator() {
        for (index, uiview) in self.indicatorView.arrangedSubviews.enumerated() {
            uiview.backgroundColor = index == currentIndex ? UIColor.white : UIColor.white.withAlphaComponent(0.6)
        }
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
