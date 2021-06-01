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
    var imageIndexs: [Int] = []
    var pageCallback: ((Int) -> Void)?
    var doCallbackInvock = false
    var autoLoopInterval = 5
    var currentCollectionIndex = 0
    var totalIndex = 100
    var totalGroup: Int {
        get {
            return totalIndex / images.count
        }
    }
    var centerGroupStartIndex: Int {
        get {
            return (totalGroup / 2) * images.count
        }
    }
    var currentIndex: Int = 0 {
        didSet {
            updateIndicator()
            if let callback = self.pageCallback {
                callback(currentIndex)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakefromnib")
    }
    
    convenience init(images: [MusicPoster] = []) {
        self.init()
        self.images = images
        for _ in 0..<totalGroup {
            for index in 0..<images.count {
                self.imageIndexs.append(index)
            }
        }
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
            maker.width.equalTo(self.images.count * 10 + (images.count - 1) * Int(indicatorView.spacing))
        }
//        currentCollectionIndex = centerGroupStartIndex
//        collectionView.scrollToItem(at: IndexPath(row: currentCollectionIndex , section: 0), at: .centeredHorizontally, animated: true)
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(autoLoopInterval), repeats: true) { timer in
            self.currentCollectionIndex += 1
            self.collectionView.scrollToItem(at: IndexPath(row: self.currentCollectionIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
        TimerManager.shared.setTimer(timerName: .musicCarouselLoop, timer: timer)
        
    }
    
    override func draw(_ rect: CGRect) {
        print("draw rect")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageIndexs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCollectionViewCell", for: indexPath) as! CarouselCollectionViewCell
        let imageIndex = imageIndexs[indexPath.row]
        cell.setContent(data: images[imageIndex])
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
    
    // scrollToItem trigger
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndScrollingAnimation")
        doCallbackInvock = true
        self.resetPositionAfterScroll(scrollView)
    }
    
    func setPage(index: Int) {
        print("setpage")
        let point = CGPoint(x: CGFloat(index) * (collectionView.frame.size.width + 30), y: collectionView.frame.origin.y)
        doCallbackInvock = false
        collectionView.setContentOffset(point, animated: true)
        currentIndex = index
    }
    
    // 人为滑动trigger
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
        self.resetPositionAfterScroll(scrollView)
    }
    
    func resetPositionAfterScroll(_ scrollView: UIScrollView) {
        let newIndex = Int(scrollView.contentOffset.x / self.frame.width)
        let realIndex = self.imageIndexs[newIndex]
        currentCollectionIndex = centerGroupStartIndex + realIndex
        collectionView.scrollToItem(at: IndexPath(row: currentCollectionIndex, section: 0), at: .centeredHorizontally, animated: false)
        currentIndex = realIndex
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
