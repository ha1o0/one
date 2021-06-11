//
//  Tab2ViewController.swift
//  one
//
//  Created by sidney on 6/11/21.
//

import UIKit

class Tab2ViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemGray4
        collectionView.snp.remakeConstraints { (maker) in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
        registerNibWithName("Tab2CollectionViewCell", collectionView: collectionView)
        registerNibWithName("LoadMoreCollectionReusableView", collectionView: collectionView, kind: UICollectionView.elementKindSectionFooter)
        self.headerRefresh()
    }
    
    override func getData() {
        super.getData()
        self.data = generateData()
    }
    
    override func loadData() {
        super.loadData()
        self.data.append(contentsOf: self.generateData())
    }
    
    func generateData() -> [SimpleVideo] {
        var newData: [SimpleVideo] = []
        for _ in 0..<4 {
            newData.append(contentsOf: MockService.shared.getRandomVideo())
        }
        return newData
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tab2CollectionViewCell", for: indexPath) as! Tab2CollectionViewCell
        cell.setContent(data: data[indexPath.row] as! SimpleVideo)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellData = self.data[indexPath.row] as! SimpleVideo
        let poster = cellData.poster
        return CGSize(width: (SCREEN_WIDTH - 10 * 3) / 2, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerVc = PlayViewController()
        self.pushVc(vc: playerVc)
    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionFooter:
//            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadMoreCollectionReusableView", for: indexPath) as! LoadMoreCollectionReusableView
//            return reusableView
//        default:
//            fatalError("Unexpected element kind")
//        }
//    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                          layout collectionViewLayout: UICollectionViewLayout,
//                          referenceSizeForFooterInSection section: Int) -> CGSize {
//        if section == 0 {
//            return CGSize(width: self.view.frame.width, height: 60)
//        }
//        return CGSize(width: self.view.frame.width, height: COLLECTION_VIEW_FOOTER_HEIGHT)
//    }
    
    func updateCollectionView() {
        collectionView.performBatchUpdates {
            
        } completion: { (result) in
            print("performBatchUpdates: \(result)")
        }
    }
}
