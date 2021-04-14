//
//  TestTableViewController.swift
//  one
//
//  Created by sidney on 2021/4/13.
//

import UIKit
import MJRefresh

class TestTableViewController: BaseTableViewController {

    var header = MJRefreshNormalHeader()
    
    var footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "使用MJ_REFRESH"
        setCustomNav()
        tableView.mj_header = header
        tableView.mj_footer = footer
        for index in 1..<16 {
            tableData.append(index)
        }
        registerNibWithName("TestTableViewCell", tableView: tableView)
        header.setRefreshingTarget(self, refreshingAction: #selector(refreshData))
        footer.setRefreshingTarget(self, refreshingAction: #selector(loadMoreData))
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TestTableViewCell = dequeueReusableCell(withIdentifier: "TestTableViewCell", tableView: tableView) as! TestTableViewCell
        cell.setContent()
        return cell
    }
    
    @objc func refreshData() {
        sleep(2)
        tableData = []
        for index in 1..<16 {
            tableData.append(index)
        }
        self.tableView.reloadData()
        self.tableView.mj_header?.endRefreshing()
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
