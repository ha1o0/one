//
//  BaseCollectionViewController.swift
//  one
//
//  Created by sidney on 2021/4/11.
//

import UIKit
import MJRefresh

enum LoadMoreStatus {
    case Loading
    case Finished
    case HaveMore
}

private let reuseIdentifier = "Cell"

class BaseCollectionViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    lazy var collectionView = UICollectionView()
    let header = CustomRefreshHeader1()
    let footer = MJRefreshAutoNormalFooter()
    var data: [Any] = []
    var dataCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: getCollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalToSuperview().offset(44 + STATUS_BAR_HEIGHT)
        }
        
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        self.collectionView.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(footerLoad))
        self.collectionView.mj_footer = footer
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // 子类重写
    func getData() {
        self.data = []
        // 重新生成新数据
    }
    
    // 子类重写
    func loadData() {
        // 添加新数据
    }
    
    @objc func headerRefresh() {
        print("下拉刷新")
        delay(2) {
            self.getData()
            self.collectionView.reloadData()
            self.collectionView.mj_header?.endRefreshing()
        }
    }

    @objc func footerLoad() {
        print("上拉加载")
        delay(2) {
            self.loadData()
            self.collectionView.reloadData()
            self.collectionView.mj_footer?.endRefreshing()
        }
    }
    
    func getCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        flowLayout.headerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 100)
//        flowLayout.footerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 100)
        let viewWidth = (SCREEN_WIDTH - 20 - flowLayout.minimumInteritemSpacing) / 2
        flowLayout.itemSize = CGSize(width: viewWidth, height: 160)
        return flowLayout
    }
    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate


    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Uncomment this method to specify if the specified item should be selected
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }

}
