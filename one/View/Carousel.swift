//
//  Carousel.swift
//  one
//
//  Created by sidney on 5/25/21.
//

import UIKit

class Carousel: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var collectionView: UICollectionView = {
        let _collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 80), collectionViewLayout: CollectionViewLayout.getFlowLayout())
        _collectionView.backgroundColor = .blue
        return _collectionView
    }()
    var images: [MusicPoster] = []

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
        registerNibWithName("CarouselCollectionViewCell", collectionView: collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCollectionViewCell", for: indexPath) as! CarouselCollectionViewCell
        return cell
    }
}
