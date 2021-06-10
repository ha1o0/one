//
//  SwitchTabCollectionLayout.swift
//  one
//
//  Created by sidney on 6/10/21.
//

import Foundation
import UIKit

class SwitchTabCollectionLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 10
//        self.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
