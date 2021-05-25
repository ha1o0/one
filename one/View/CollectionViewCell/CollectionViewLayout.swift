//
//  CollectionViewLayout.swift
//  one
//
//  Created by sidney on 5/25/21.
//

import Foundation
import UIKit

class CollectionViewLayout {
    static func getFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = SCREEN_WIDTH - 30
        layout.itemSize = CGSize(width: itemWidth, height: 120)
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = 30
        layout.minimumLineSpacing = 5
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.scrollDirection = .horizontal

        return layout
    }
}
