//
//  HomeViewController.swift
//  one
//
//  Created by sidney on 2021/3/21.
//

import UIKit

class HomeViewController: BaseViewController, UISearchBarDelegate {

    lazy var navigationView = UIView()
    lazy var avatarImageView = UIImageView()
    lazy var searchBoxView = UISearchBar()
    lazy var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("clicked")
        searchBoxView.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("begin edit")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("end edit")
    }
    
    @objc func toPlayView() {
        self.navigationController?.pushViewController(PlayViewController(), animated: true)
    }
    
    override func setNavigation() {
        
        super.setNavigation()
        
        let statusView = UIView()
        self.view.addSubview(statusView)
        statusView.backgroundColor = UIColor.main
        statusView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(0)
            maker.left.equalTo(self.view).offset(0)
            maker.trailing.equalTo(self.view).offset(0)
            maker.height.equalTo(STATUS_BAR_HEIGHT)
        }
        
        self.view.addSubview(navigationView)
        navigationView.backgroundColor = UIColor.main
        navigationView.snp.makeConstraints { (maker) in
            maker.top.equalTo(statusView.snp.bottom).offset(0)
            maker.left.equalTo(self.view).offset(0)
            maker.trailing.equalTo(self.view).offset(0)
            maker.height.equalTo(44)
        }
        
        //头像
        avatarImageView.isUserInteractionEnabled = true
        navigationView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(33)
            maker.height.equalTo(33)
        }

        let avatarGesture = UITapGestureRecognizer(target: self, action: #selector(toPlayView))
        avatarImageView.addGestureRecognizer(avatarGesture)
        let avatarUrl = "http://b-ssl.duitang.com/uploads/item/201809/24/20180924092018_zjgut.jpg"
        avatarImageView.loadFrom(link: avatarUrl, isCircle: true)
        navigationView.bringSubviewToFront(avatarImageView)
        
        setSearchBar()
        
        //扫一扫和消息图标
        let messageIconView = UIImageView()
        messageIconView.image = UIImage(named: "message")
        navigationView.addSubview(messageIconView)
        messageIconView.snp.makeConstraints { (maker) in
            maker.width.equalTo(25)
            maker.height.equalTo(25)
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-15)
        }
        let scanIconView = UIImageView()
        scanIconView.image = UIImage(named: "scan")
        navigationView.addSubview(scanIconView)
        scanIconView.snp.makeConstraints { (maker) in
            maker.width.equalTo(20)
            maker.height.equalTo(20)
            maker.centerY.equalToSuperview()
            maker.trailing.equalTo(messageIconView.snp.leading).offset(-20)
        }
    }
    
    func setSearchBar() {
        //搜索框
        let searchBoxBgView = UIImageView()
        let insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        // 用圆形图片左右拉伸成搜索框图形作为背景图
        searchBoxBgView.image = UIImage(named: "circle_white")?.resizableImage(withCapInsets: insets)
        navigationView.addSubview(searchBoxBgView)
        searchBoxBgView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(avatarImageView.snp.trailing).offset(15)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(hasSafeArea ? 250 : 200)
            maker.height.equalTo(30)
        }
        
        searchBoxView.delegate = self
        navigationView.addSubview(searchBoxView)
        searchBoxView.barTintColor = UIColor.clear
        searchBoxView.tintColor = UIColor.main
        searchBoxView.searchTextPositionAdjustment = UIOffset(horizontal: 8, vertical: 1)
        let textField = searchBoxView.value(forKey: "searchField") as! UITextField
        textField.layer.cornerRadius = 18
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.lightGray
        textField.tintColor = UIColor.main
        textField.backgroundColor = UIColor.clear
        textField.placeholder = "搜索"
        textField.enablesReturnKeyAutomatically = false //text为空时return key依然可用
        searchBoxView.backgroundImage = UIImage()
        searchBoxView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(260)
            maker.height.equalTo(30)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
