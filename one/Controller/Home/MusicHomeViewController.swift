//
//  MusicHomeViewController.swift
//  one
//
//  Created by sidney on 5/19/21.
//

import UIKit
import MJRefresh

class MusicHomeViewController: BaseTableViewController {

    lazy var menuButton: UIButton = {
        let _menuButton = UIButton.getSystemIconBtn(name: "text.alignleft", color: .black)
        _menuButton.addTarget(self, action: #selector(showLeftVc), for: .touchUpInside)
        return _menuButton
    }()
    
    lazy var weatherButton: UIButton = {
        let _weatherButton = UIButton.getSystemIconBtn(name: "sun.max.fill", color: .black)
        return _weatherButton
    }()
    
    var header = MJRefreshNormalHeader()
    var footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        setTableView()
        setNavigation()
        tableData = []
        var posters: [MusicPoster] = []
        posters.append(MusicPoster(url: "https://is1-ssl.mzstatic.com/image/thumb/Music128/v4/aa/d4/70/aad470fd-e8cd-88f6-c00c-c194ebbb783d/source/600x600bb.jpg", color: .gray))
        posters.append(MusicPoster(url: "https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/b8/19/d9/b819d9a3-0207-2725-68c5-6e5529b1e8b2/source/600x600bb.jpg", color: .blue))
        posters.append(MusicPoster(url: "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/2e/57/8c/2e578c02-c391-26f5-fb39-35c17a344f3a/source/600x600bb.jpg", color: .purple))
        let posterItem = MusicHomeItem(posters: posters)
        tableData.append(MusicHomeSection(type: .poster, items: [posterItem], title: ""))
    }
    
    override func setNavigation() {
        super.setStatusBar()
        super.setNavigation()

        self.view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(STATUS_BAR_HEIGHT)
            maker.left.equalToSuperview().offset(0)
            maker.trailing.equalToSuperview().offset(0)
            maker.height.equalTo(44)
        }
        
        navigationView.addSubview(menuButton)
        menuButton.snp.makeConstraints({ (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(20)
        })
        
        navigationView.addSubview(weatherButton)
        weatherButton.snp.makeConstraints({ (maker) in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-20)
        })
        
        let transColor: UIColor = .white.withAlphaComponent(0.8)
        self.statusBarView.backgroundColor = transColor
        self.navigationView.backgroundColor = transColor
    }
    
    func setTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .main
    }
    
    @objc func showLeftVc() {
        appDelegate.rootVc?.drawerVc.openLeftVc()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
