//
//  CollectionViewLayout.swift
//  one
//
//  Created by sidney on 5/25/21.
//

import Foundation
import UIKit

class CollectionViewLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.itemSize = CGSize(width: SCREEN_WIDTH - 30, height: 150)
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
//        self.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


