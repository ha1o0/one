//
//  Tab2ViewController.swift
//  one
//
//  Created by sidney on 6/11/21.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func reloadIndexPath(_ indexPath: IndexPath)
    func deleteIndexPath(_ indexPath: IndexPath)
}

class Tab2ViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {

    var loadMoreStatus: LoadMoreStatus = .HaveMore
    
    override func viewDidLoad() {
        let layout = Tab2FlowLayout()
        layout.estimatedItemSize = CGSize(width: (SCREEN_WIDTH - 30) / 2, height: 100)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        super.viewDidLoad()
        collectionView.backgroundColor = .systemGray4
        collectionView.snp.remakeConstraints { (maker) in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
        self.collectionView.mj_footer = nil
        registerNibWithName("Tab2CollectionViewCell", collectionView: collectionView)
        registerNibWithName("LoadMoreCollectionReusableView", collectionView: collectionView, kind: UICollectionView.elementKindSectionFooter)
        self.headerRefresh()
    }
    
    @objc override func headerRefresh() {
        print("下拉刷新")
        delay(2) {
            self.getData()
        }
    }

    @objc override func footerLoad() {
        print("上拉加载")
    }
    
    override func getData() {
        let newData = generateData()
        let newImageUrls = newData.map { (simpleVideo) -> String in
            return simpleVideo.poster
        }
        CacheManager.shared.preCache(urlstrs: newImageUrls) {
            self.data = newData
            self.collectionView.reloadSections(IndexSet(integer: 0))
            self.collectionView.mj_header?.endRefreshing()
        }
    }
    
    @objc func loadMore() {
        let newData = generateData()
        loadMoreStatus = .Finished
        let newImageUrls = newData.map { (simpleVideo) -> String in
            return simpleVideo.poster
        }
        delay(2) {
            let newIndexPaths = newData.enumerated().map { (index, _) -> IndexPath in
                return IndexPath(row: index + self.data.count, section: 0)
            }
            CacheManager.shared.preCache(urlstrs: newImageUrls) {
                self.data.append(contentsOf: newData)
                self.collectionView.insertItems(at: newIndexPaths)
            }
        }
    }
    
    func generateData() -> [SimpleVideo] {
        var newData: [SimpleVideo] = []
        for _ in 0..<4 {
            newData.append(contentsOf: MockService.shared.getRandomVideo())
        }
        return newData
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tab2CollectionViewCell", for: indexPath) as! Tab2CollectionViewCell
        cell.delegate = self
        cell.setContent(data: data[indexPath.row] as! SimpleVideo, indexPath: indexPath)

        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellData = self.data[indexPath.row] as! SimpleVideo
//        let poster = cellData.poster
//        return CGSize(width: (SCREEN_WIDTH - 10 * 3) / 2, height: 250)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerVc = PlayViewController()
        self.pushVc(vc: playerVc)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.row == data.count - 1 && loadMoreStatus != .Loading {
                print("loadmore")
                loadMoreStatus = .Loading
                self.loadMore()
            }
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

extension Tab2ViewController: CollectionViewCellDelegate {
    func reloadIndexPath(_ indexPath: IndexPath) {
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    func deleteIndexPath(_ indexPath: IndexPath) {
        self.data.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
    }
}
