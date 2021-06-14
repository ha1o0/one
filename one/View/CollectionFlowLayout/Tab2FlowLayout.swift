//
//  Tab2FlowLayout.swift
//  one
//
//  Created by sidney on 2021/6/13.
//

import Foundation
import UIKit

class Tab2FlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        self.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrbutesToReturn: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) ?? []
        for attributes in attrbutesToReturn {
            if nil == attributes.representedElementKind {
                let indexPath = attributes.indexPath
                attributes.frame = self.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
            }
        }
        return attrbutesToReturn
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)
        if indexPath.item < 2 {
            var f = currentItemAttributes?.frame
            f?.origin.y = 10
            currentItemAttributes?.frame = f ?? .zero
            return currentItemAttributes
        }
        let ipPrev: IndexPath = IndexPath(item: indexPath.item - 2, section: indexPath.section)
        if let fPrev = self.layoutAttributesForItem(at: ipPrev)?.frame {
            let YPointNew = fPrev.origin.y + fPrev.size.height + 10
            if var f = currentItemAttributes?.frame {
                f.origin.y = YPointNew
                currentItemAttributes?.frame = f
            }
        }
        
        
        return currentItemAttributes
    }
}
