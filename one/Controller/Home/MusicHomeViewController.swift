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
    
    lazy var toptopShadowView: UIView = {
        let _topShadowView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        return _topShadowView
    }()
    
    var header = MJRefreshNormalHeader()
    var footer = MJRefreshAutoNormalFooter()
    var posters: [MusicPoster] = []
    var functions: [MusicFunction] = []
    var recommendedMusics: [MusicSheet] = []
    var musics: [Music] = []
    
    override func viewDidLoad() {
        setTableView()
        setNavigation()
        tableData = []
        posters.append(MusicPoster(url: "https://i.loli.net/2021/05/26/BOs7DMaKW86TLc4.jpg", color: .gray))
        posters.append(MusicPoster(url: "https://i.loli.net/2021/05/26/rVnT7Sf1N3ICw9j.jpg", color: .blue))
        posters.append(MusicPoster(url: "https://i.loli.net/2021/05/26/XFqhaPOEY19rBAJ.jpg", color: .purple))
        tableData.append(MusicHomeSection(type: .poster, items: posters, title: ""))

        functions.append(MusicFunction(icon: "calendar", name: "每日推荐", to: ""))
        functions.append(MusicFunction(icon: "bus", name: "私人FM", to: ""))
        functions.append(MusicFunction(icon: "book", name: "歌单", to: ""))
        functions.append(MusicFunction(icon: "rank", name: "排行榜", to: ""))
        functions.append(MusicFunction(icon: "movie", name: "数字专辑", to: ""))
        functions.append(MusicFunction(icon: "voice", name: "歌房", to: ""))
        functions.append(MusicFunction(icon: "rmb", name: "游戏专区", to: ""))
        tableData.append(MusicHomeSection(type: .function, items: functions, title: ""))
        
        let posterUrlstrs = ["https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/42/57/7e/42577e30-e629-c07e-98f0-201a4ffca0cf/source/600x600bb.jpg",
                             "https://is3-ssl.mzstatic.com/image/thumb/Music124/v4/77/56/37/77563720-c2e3-d584-e030-69e6da668ec4/source/600x600bb.jpg",
                             "https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/54/44/50/544450ff-aaf4-79a9-1b3b-c52fb598f4fb/source/600x600bb.jpg",
                             "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/a9/85/64/a9856465-eacc-b533-b127-9796607ddb08/source/600x600bb.jpg",
                            ]
        
        recommendedMusics.append(MusicSheet(name: "数尽荒芜过后 必定会有新生", id: "1", posters: posterUrlstrs, playCount: 0))
        recommendedMusics.append(MusicSheet(name: "今天从《千百度》听起 | 私人雷达", id: "2", posters: ["https://is5-ssl.mzstatic.com/image/thumb/Music115/v4/18/37/0d/18370d53-e146-a295-9da4-f772fbbde252/source/600x600bb.jpg"], playCount: 0))
        recommendedMusics.append(MusicSheet(name: "全网畅销流行热歌", id: "3", posters: ["https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/4c/90/b5/4c90b552-8b6d-c1f5-20ee-5cb1665a5c12/source/600x600bb.jpg"], playCount: 0))
        recommendedMusics.append(MusicSheet(name: "让耳朵怀孕的抒情网络热歌", id: "4", posters: ["https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/d0/d1/f8/d0d1f881-cc97-0167-a6c2-65cd54f6eb49/source/600x600bb.jpg"], playCount: 0))
        recommendedMusics.append(MusicSheet(name: "渡过失恋期Cover集", id: "5", posters: ["https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/c2/c9/3d/c2c93de5-7e64-f98b-9247-bffa6076d47c/source/600x600bb.jpg"], playCount: 0))
        recommendedMusics.append(MusicSheet(name: "时间治愈的是 愿意自渡之人", id: "6", posters: ["https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/03/26/12/032612ad-88f5-176f-1822-e6e19a642c5f/source/600x600bb.jpg"], playCount: 0))
        
        musics.append(Music(id: "1", poster: "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/d0/d1/f8/d0d1f881-cc97-0167-a6c2-65cd54f6eb49/source/600x600bb.jpg", name: "千百度", subtitle: "众里寻他千百度", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "2", poster: "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/d0/d1/f8/d0d1f881-cc97-0167-a6c2-65cd54f6eb49/source/600x600bb.jpg", name: "千百度", subtitle: "众里寻他千百度", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "3", poster: "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/d0/d1/f8/d0d1f881-cc97-0167-a6c2-65cd54f6eb49/source/600x600bb.jpg", name: "千百度", subtitle: "众里寻他千百度", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "4", poster: "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/d0/d1/f8/d0d1f881-cc97-0167-a6c2-65cd54f6eb49/source/600x600bb.jpg", name: "千百度", subtitle: "众里寻他千百度", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "5", poster: "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/d0/d1/f8/d0d1f881-cc97-0167-a6c2-65cd54f6eb49/source/600x600bb.jpg", name: "千百度", subtitle: "众里寻他千百度", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "6", poster: "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/d0/d1/f8/d0d1f881-cc97-0167-a6c2-65cd54f6eb49/source/600x600bb.jpg", name: "千百度", subtitle: "众里寻他千百度", playCount: 0, author: "许嵩"))
        
        CacheManager.shared.preCache(urlstrs: posterUrlstrs) {
            self.tableData.append(MusicHomeSection(type: .musicSheet, items: self.recommendedMusics, title: "推荐歌单"))
            self.tableData.append(MusicHomeSection(type: .musicList, items: self.musics, title: "送你一壶古风酿的酒"))
            self.tableView.reloadData()
        }
        
        self.updateTopViewImage(pageIndex: 0)
    }
    
    override func setNavigation() {
        super.setStatusBar()
        super.setNavigation()

        self.view.backgroundColor = UIColor.white
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
        
//        self.view.addSubview(toptopShadowView)
//        toptopShadowView.snp.makeConstraints { (maker) in
//            maker.top.leading.trailing.equalToSuperview()
//            maker.height.equalTo(STATUS_NAV_HEIGHT + 180)
//        }
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
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerData = tableData[section] as! MusicHomeSection
        let header = UIView()
        if section == 0 {
            let carousel = Carousel(images: headerData.items as! [MusicPoster])
            carousel.pageCallback = self.updateTopViewImage
            header.addSubview(carousel)
            carousel.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview().offset(15)
                maker.bottom.equalToSuperview().offset(-15)
                maker.leading.equalToSuperview().offset(15)
                maker.trailing.equalToSuperview().offset(-15)
            }
        }
        if section == 1 {
            let functionView = MusicFunctionView(functions: headerData.items as! [MusicFunction])
            header.addSubview(functionView)
            functionView.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview().offset(10)
                maker.bottom.equalToSuperview().offset(-10)
                maker.leading.equalToSuperview().offset(10)
                maker.trailing.equalToSuperview().offset(-10)
            }
        }
        if section == 2 {
            let musicSheetView = MusicSheetView(musicSheets: headerData.items as! [MusicSheet], headerName: headerData.title)
            header.addSubview(musicSheetView)
            musicSheetView.snp.makeConstraints { maker in
                maker.top.equalToSuperview().offset(10)
                maker.bottom.equalToSuperview().offset(-10)
                maker.leading.equalToSuperview().offset(10)
                maker.trailing.equalToSuperview().offset(-10)
            }
        }
        if section == 3 {
            let musicListView = MusicListView(musics: headerData.items as! [Music], headerName: headerData.title)
            header.addSubview(musicListView)
            musicListView.snp.makeConstraints { maker in
                maker.top.equalToSuperview().offset(10)
                maker.bottom.equalToSuperview().offset(-10)
                maker.leading.equalToSuperview().offset(10)
                maker.trailing.equalToSuperview().offset(-10)
            }
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 180
        }
        if section == 1 {
            return 80
        }
        if section == 2 {
            return 220
        }
        if section == 3 {
            return 220
        }
        return .leastNonzeroMagnitude
    }
    
    func updateTopViewImage(pageIndex: Int) {
        if let url = URL(string: posters[pageIndex].url) {
            topImageView.loadFrom(url: url)
        }
    }
}
