//
//  MusicHomeViewController.swift
//  one
//
//  Created by sidney on 5/19/21.
//

import UIKit

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
    
    override func viewDidLoad() {
        setTableView()
        setNavigation()
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
