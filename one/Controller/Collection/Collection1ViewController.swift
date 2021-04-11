//
//  Collection1ViewController.swift
//  one
//
//  Created by sidney on 2021/3/26.
//

import UIKit

class Collection1ViewController: BaseCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "集合"
        setCustomNav()
        registerNibWithName("PictureCollectionViewCell", collectionView: collectionView)
        data = []
        dataCount += updateData()
        // Do any additional setup after loading the view.
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
        self.navigationController?.pushViewController(playerVc, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (CGFloat(data.count / 2 * 160) - collectionView.frame.height) {
            let newCount = updateData()
//            self.collectionView.insertItems(at: [IndexPath(row: data.count - newCount - 1, section: 0)])
            self.collectionView.performBatchUpdates {
                dataCount += newCount
            } completion: { (result) in
                print("performBatchUpdates: \(result)")
            }
        }
    }
    
    func updateData() -> Int {
        for _ in 0..<16 {
            data.append(generateData())
        }
        return 16
    }
    
    func generateData() -> Video {
        return Video(id: "1", type: "1", title: "《乘风破浪的姐姐》我曾难自拔于世界之大", subtitle: "猜你喜欢 · 芒果视频", poster: "https://blog.iword.win/images/langjie.png", url: "https://blog.iword.win/langjie.mp4")
    }

}
