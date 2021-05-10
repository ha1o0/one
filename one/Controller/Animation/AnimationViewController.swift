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
//        print("animation didload")
        title = "动画"
        setCustomNav()
        tableData = []
        tableData.append(Animation(name: "平移", id: "1", type: "transform"))
        tableData.append(Animation(name: "旋转", id: "2", type: "rotate"))
        tableData.append(Animation(name: "翻转", id: "3", type: "rotate3d"))
        tableData.append(Animation(name: "抖动", id: "4", type: "spring"))
        registerCellWithClass(Animation2TableViewCell.self, tableView: tableView)
        registerCellWithClass(Animation3TableViewCell.self, tableView: tableView)
        registerCellWithClass(Animation4TableViewCell.self, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tableData[indexPath.row] as? Animation
        var cell: UITableViewCell
        switch data?.type {
        case "rotate":
            cell = dequeueReusableCell(withIdentifier: "Animation2TableViewCell", tableView: tableView) as! Animation2TableViewCell
        case "rotate3d":
            cell = dequeueReusableCell(withIdentifier: "Animation3TableViewCell", tableView: tableView) as! Animation3TableViewCell
        case "spring":
            cell = dequeueReusableCell(withIdentifier: "Animation4TableViewCell", tableView: tableView) as! Animation4TableViewCell
        default:
            cell = dequeueReusableCell(withIdentifier: "Animation1TableViewCell", tableView: tableView) as! Animation1TableViewCell
        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("animation willappear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("animation didappear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        print("animation willdisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        print("animation diddisappear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        print("animation willlayoutsubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("animation didlayoutsubviews")
    }
    
}
