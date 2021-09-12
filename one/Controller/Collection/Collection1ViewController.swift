//
//  Collection1ViewController.swift
//  one
//
//  Created by sidney on 2021/3/26.
//

import UIKit


class Collection1ViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: getCollectionViewFlowLayout())
        super.viewDidLoad()
        self.title = "集合"
        setCustomNav()
        registerNibWithName("PictureCollectionViewCell", collectionView: collectionView)
        registerNibWithName("LoadMoreCollectionReusableView", collectionView: collectionView, kind: UICollectionView.elementKindSectionFooter)
        self.headerRefresh()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath) as! PictureCollectionViewCell
        cell.setCell(data: data[indexPath.row] as! Video)

        return cell
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
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 60)
    }
    
    func updateCollectionView() {
        collectionView.performBatchUpdates {
            
        } completion: { (result) in
            print("performBatchUpdates: \(result)")
        }
    }
    
    override func getData() {
        super.getData()
        self.data = generateData()
    }
    
    override func loadData() {
        super.loadData()
        self.data.append(contentsOf: self.generateData())
    }
    
    func generateData() -> [Video] {
        var newData: [Video] = []
        for index in 0..<16 {
            newData.append(Video(id: "1", type: "1", title: "《乘风破浪的姐姐》我曾难自拔于世界之大", subtitle: "猜你喜欢 · 芒果视频\(index)-", poster: MockService.shared.getRandomImg(), url: "https://blog.iword.win/langjie.mp4"))
        }
        return newData
    }

}
