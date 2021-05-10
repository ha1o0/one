//
//  Collection1ViewController.swift
//  one
//
//  Created by sidney on 2021/3/26.
//

import UIKit


class Collection1ViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "集合"
        setCustomNav()
        registerNibWithName("PictureCollectionViewCell", collectionView: collectionView)
        registerNibWithName("LoadMoreCollectionReusableView", collectionView: collectionView, kind: UICollectionView.elementKindSectionFooter)
        data = []
        dataCount += loadMore()
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath) as! PictureCollectionViewCell
        cell.setCell(data: data[indexPath.row] as! Video)
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cellData = data[indexPath.row] as! Video
//        let url = cellData.url
        let playerVc = PlayViewController()
        self.pushVc(vc: playerVc)
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= (CGFloat(data.count / 2 * 160) - collectionView.frame.height) {
//            let newCount = loadMore()
//            self.collectionView.performBatchUpdates {
//                dataCount += newCount
//            } completion: { (result) in
//                print("performBatchUpdates: \(result)")
//            }
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1 && loadMoreStatus != .Loading {
            loadMoreStatus = .Loading
//            dataCount += loadMore()
            self.perform(#selector(loadMore), with: self, afterDelay: 3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadMoreCollectionReusableView", for: indexPath) as! LoadMoreCollectionReusableView
            return reusableView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
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
    
    @objc func loadMore() -> Int {
        for index in 0..<16 {
            data.append(generateData(index))
        }
        loadMoreStatus = .Finished
        // 主线程执行，避免前面的cell消失
        DispatchQueue.main.async(execute: collectionView.reloadData)
        return 16
    }
    
    func generateData(_ index: Int) -> Video {
        return Video(id: "1", type: "1", title: "《乘风破浪的姐姐》我曾难自拔于世界之大", subtitle: "猜你喜欢 · 芒果视频\(index)-", poster: "https://blog.iword.win/images/langjie.png", url: "https://blog.iword.win/langjie.mp4")
    }

}
