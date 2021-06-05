//
//  MusicListCollectionViewLayout.swift
//  one
//
//  Created by sidney on 2021/6/4.
//

import Foundation
import UIKit

class MusicListCollectionViewLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    var itemWidth: CGFloat = SCREEN_WIDTH - 50
    
    override init() {
        super.init()
        self.itemSize = CGSize(width: itemWidth, height: 70)
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepare() {
//        super.prepare()
//        guard let collectionView = collectionView else { return }
//        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast // mostly you want it fast!
//    }
    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        print("proposedContentOffset: \(proposedContentOffset)")
//        let page = ceil(proposedContentOffset.x / (self.collectionView?.bounds.width)!)
//        print(page)
//        let newContentOffset = CGPoint(x: CGFloat(page) * itemWidth, y: proposedContentOffset.y)
//        print("newContentOffset: \(newContentOffset)")
//        return newContentOffset
//    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        guard let collectionView = collectionView else { return proposedContentOffset }
        print("origin: \(proposedContentOffset.x), velocity: \(velocity)")
        let pageWidth = itemSize.width + minimumLineSpacing
        let currentPage: CGFloat = collectionView.contentOffset.x / pageWidth
        let nearestPage: CGFloat = round(currentPage)
        let isNearPreviousPage = nearestPage < currentPage

        var pageDiff: CGFloat = 0
        let velocityThreshold: CGFloat = 0.5 // can customize this threshold
        if isNearPreviousPage {
          if velocity.x > velocityThreshold {
            pageDiff = 1
          }
        } else {
          if velocity.x < -velocityThreshold {
            pageDiff = -1
          }
        }

        let x = (nearestPage + pageDiff) * pageWidth
        let cappedX = max(0, x) // cap to avoid targeting beyond content
        print("x:", cappedX, "velocity:", velocity)
        return CGPoint(x: cappedX, y: proposedContentOffset.y)
      }
    
//    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool {
//        return true
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        let cellSize = CGSize(width: itemWidth, height: 70)
//        return cellSize
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
//    {
//        let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat((collectionView.numberOfItems(inSection: 0) / 3 - 1) * 30))
//        return sectionInset
//    }
}
