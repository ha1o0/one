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
    
    lazy var topImageView: UIImageView = {
        let _topImageView = UIImageView()
        _topImageView.contentMode = .scaleAspectFill
        return _topImageView
    }()
    
    lazy var topView: UIView = {
        let _topView = UIView()
        _topView.addSubview(topImageView)
        topImageView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        return _topView
    }()
    
    lazy var topShadowView: UIView = {
        let _topShadowView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        return _topShadowView
    }()
    
    var header = MJRefreshNormalHeader()
    var footer = MJRefreshAutoNormalFooter()
    var posters: [MusicPoster] = []
    var functions: [MusicFunction] = []
    
    override func viewDidLoad() {
        setTableView()
        setNavigation()
        tableData = []
        posters.append(MusicPoster(url: "https://i.loli.net/2021/05/26/BOs7DMaKW86TLc4.jpg", color: .gray))
        posters.append(MusicPoster(url: "https://i.loli.net/2021/05/26/rVnT7Sf1N3ICw9j.jpg", color: .blue))
        posters.append(MusicPoster(url: "https://i.loli.net/2021/05/26/XFqhaPOEY19rBAJ.jpg", color: .purple))
        let posterItem = MusicHomeItem(posters: posters)
        tableData.append(MusicHomeSection(type: .poster, items: [posterItem], title: ""))

        functions.append(MusicFunction(icon: "calendar", name: "每日推荐", to: ""))
        functions.append(MusicFunction(icon: "bus", name: "私人FM", to: ""))
        functions.append(MusicFunction(icon: "book", name: "歌单", to: ""))
        functions.append(MusicFunction(icon: "rank", name: "排行榜", to: ""))
        functions.append(MusicFunction(icon: "movie", name: "数字专辑", to: ""))
        functions.append(MusicFunction(icon: "voice", name: "歌房", to: ""))
        functions.append(MusicFunction(icon: "rmb", name: "游戏专区", to: ""))
        self.updateTopViewImage(pageIndex: 0)
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
        
        let transColor: UIColor = UIColor.white.withAlphaComponent(0.5)
        self.statusBarView.backgroundColor = transColor
        self.navigationView.backgroundColor = transColor
    }
    
    func setTableView() {
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(STATUS_NAV_HEIGHT + 180)
        }

        self.view.addSubview(topShadowView)
        topShadowView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(STATUS_NAV_HEIGHT + 180)
        }
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalToSuperview().offset(hasNotch ? 88 : 64)
        }
        tableView.mj_header = header
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        header.setRefreshingTarget(self, refreshingAction: #selector(refreshData))
    }
    
    @objc func refreshData() {
        sleep(1)
        self.tableView.reloadData()
        self.tableView.mj_header?.endRefreshing()
        self.updateTopViewImage(pageIndex: 0)
    }
    
    @objc func showLeftVc() {
        appDelegate.rootVc?.drawerVc.openLeftVc()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        if section == 0 {
            let carousel = Carousel(images: posters)
            carousel.pageCallback = self.updateTopViewImage
            header.addSubview(carousel)
            carousel.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview().offset(15)
                maker.bottom.equalToSuperview().offset(-15)
                maker.leading.equalToSuperview().offset(15)
                maker.trailing.equalToSuperview().offset(-15)
            }
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 180
        }
        return .leastNonzeroMagnitude
    }
    
    func updateTopViewImage(pageIndex: Int) {
        if let url = URL(string: posters[pageIndex].url) {
            topImageView.loadFrom(url: url)
        }
    }
}
