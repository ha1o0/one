//
//  Tab1ViewController.swift
//  one
//
//  Created by sidney on 6/11/21.
//

import UIKit
import MJRefresh

class Tab1ViewController: BaseTableViewController {
    
    var header = MJRefreshNormalHeader()
    var footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        tableView = UITableView(frame: .zero, style: .plain)
        super.viewDidLoad()
        tableView.snp.remakeConstraints({ maker in
            maker.top.leading.trailing.bottom.equalToSuperview()
        })
        tableView.mj_header = header
        tableView.mj_footer = footer
        for index in 1..<16 {
            tableData.append(index)
        }
        registerNibWithName("TestTableViewCell", tableView: tableView)
        header.setRefreshingTarget(self, refreshingAction: #selector(refreshData))
        footer.setRefreshingTarget(self, refreshingAction: #selector(loadMoreData))
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TestTableViewCell = dequeueReusableCell(withIdentifier: "TestTableViewCell", tableView: tableView) as! TestTableViewCell
        cell.setContent()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return COLLECTION_VIEW_FOOTER_HEIGHT - footer.frame.height
//    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footer = UIView()
//        footer.backgroundColor = .yellow
//        return footer
//    }
    
    @objc func refreshData() {
        delay(2) {
            self.tableData = []
            for index in 1..<16 {
                self.tableData.append(index)
            }
            self.tableView.reloadData()
            self.tableView.mj_header?.endRefreshing()
        }
    }
    
    @objc func loadMoreData() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            for index in 1..<16 {
                self.tableData.append(index)
            }
            self.tableView.reloadData()
            self.tableView.mj_footer?.endRefreshing()
        }
    }

}
