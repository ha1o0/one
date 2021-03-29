//
//  AnimationViewController.swift
//  one
//
//  Created by sidney on 2021/3/29.
//

import UIKit



class AnimationViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "动画"
        setCustomNav()
        tableView.backgroundColor = .lightGray
        tableData = []
        tableData.append(Animation(name: "平移", id: "1", type: "transform"))
        tableData.append(Animation(name: "旋转", id: "2", type: "rotate"))
        registerCellWithClass(Animation2TableViewCell.self, tableView: tableView)
        registerCellWithClass(AnimationTableViewCell.self, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tableData[indexPath.row] as? Animation
        var cell: UITableViewCell
        switch data?.type {
        case "rotate":
            cell = dequeueReusableCell(withIdentifier: "Animation2TableViewCell", tableView: tableView) as! Animation2TableViewCell
        default:
            cell = dequeueReusableCell(withIdentifier: "Animation1TableViewCell", tableView: tableView) as! Animation1TableViewCell
        }
        
        return cell
    }
}
