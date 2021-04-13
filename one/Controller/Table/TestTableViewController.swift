//
//  TestTableViewController.swift
//  one
//
//  Created by sidney on 2021/4/13.
//

import UIKit
import MJRefresh

class TestTableViewController: BaseTableViewController {

    lazy var header: MJRefreshHeader = {
        return MJRefreshHeader()
    }()
    
    lazy var footer: MJRefreshFooter = {
        return MJRefreshFooter()
    }()
    
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
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TestTableViewCell = dequeueReusableCell(withIdentifier: "TestTableViewCell", tableView: tableView) as! TestTableViewCell
        cell.setContent()
        return cell
    }
    

}
