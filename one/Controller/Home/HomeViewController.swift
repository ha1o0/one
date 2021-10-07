//
//  HomeViewController.swift
//  one
//
//  Created by sidney on 2021/3/21.
//

import UIKit

class HomeViewController: BaseTabBarViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var avatarImageView = UIImageView()
    lazy var searchBoxView = UISearchBar()
    lazy var scanIconView = UIImageView()
    lazy var messageIconView = UIImageView()
    lazy var tableView = UITableView()
    var tableViewData: [IdName] = []
    var tableViewDataCopy: [IdName] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setTableView()
        let aa = [1,2,3,4,5]
        let bb = aa.count / 3
        print(ceil(Double(bb)))
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func toPlayView() {
        self.pushVc(vc: PlayViewController())
    }
    
    override func setNavigation() {
        super.setStatusBar()
        super.setNavigation()

        self.view.addSubview(navigationView)
        navigationView.backgroundColor = UIColor.main
        navigationView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(STATUS_BAR_HEIGHT)
            maker.left.equalToSuperview().offset(0)
            maker.trailing.equalToSuperview().offset(0)
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
        avatarImageView.loadFrom(link: avatarUrl, isCircle: false)
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.layer.masksToBounds = true
        navigationView.bringSubviewToFront(avatarImageView)
        
        //扫一扫和消息图标
        messageIconView.image = UIImage(named: "message")
        navigationView.addSubview(messageIconView)
        messageIconView.snp.makeConstraints { (maker) in
            maker.width.equalTo(25)
            maker.height.equalTo(25)
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-15)
        }
        messageIconView.isUserInteractionEnabled = true
        let mtapGesture = UITapGestureRecognizer(target: self, action: #selector(toMessageVc))
        messageIconView.addGestureRecognizer(mtapGesture)
        
        
        scanIconView.image = UIImage(named: "scan")
        navigationView.addSubview(scanIconView)
        scanIconView.snp.makeConstraints { (maker) in
            maker.width.equalTo(20)
            maker.height.equalTo(20)
            maker.centerY.equalToSuperview()
            maker.trailing.equalTo(messageIconView.snp.leading).offset(-20)
        }
        scanIconView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toScanQRCodeVc))
        scanIconView.addGestureRecognizer(tapGesture)
        
        setSearchBar()
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
            maker.width.equalTo(hasNotch ? 250 : 200)
            maker.height.equalTo(30)
        }
        
        searchBoxView.delegate = self
        navigationView.addSubview(searchBoxView)
        searchBoxView.barTintColor = UIColor.clear
        searchBoxView.tintColor = UIColor.main
        searchBoxView.searchTextPositionAdjustment = UIOffset(horizontal: 8, vertical: 1)
        let textField = searchBoxView.value(forKey: "searchField") as! UITextField
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.white
        textField.backgroundColor = UIColor.mainBkg.withAlphaComponent(0.6)
        textField.attributedPlaceholder = NSAttributedString(string: "搜索", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        textField.enablesReturnKeyAutomatically = false //text为空时return key依然可用
        searchBoxView.backgroundImage = UIImage()
        searchBoxView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(30)
            maker.trailing.equalTo(self.scanIconView.snp.leading).offset(-15)
        }
    }
    
    func setTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.backgroundColor = .systemGray6
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableViewData.append(IdName(name: "视频播放器", id: "1"))
        self.tableViewData.append(IdName(name: "音乐播放器", id: "12"))
        self.tableViewData.append(IdName(name: "动画", id: "2"))
        self.tableViewData.append(IdName(name: "贝塞尔曲线", id: "3"))
        self.tableViewData.append(IdName(name: "UITableView", id: "4"))
        self.tableViewData.append(IdName(name: "UICollectionView", id: "5"))
        self.tableViewData.append(IdName(name: "地图", id: "6"))
        self.tableViewData.append(IdName(name: "Controller转场动画", id: "7"))
        self.tableViewData.append(IdName(name: "SceneKit", id: "8"))
        self.tableViewData.append(IdName(name: "WebView", id: "9"))
        self.tableViewData.append(IdName(name: "相机", id: "10"))
        self.tableViewData.append(IdName(name: "多线程", id: "13"))
        self.tableViewData.append(IdName(name: "录音", id: "11"))
        self.tableViewData.append(IdName(name: "CoreData", id: "14"))
        self.tableViewData.append(IdName(name: "测试", id: "0"))

        self.tableView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalTo(self.navigationView.snp.bottom)
            maker.bottom.equalToSuperview()
        }
        tableView.tableFooterView = UIView()
        self.tableViewDataCopy = self.tableViewData
    }
    
    @objc func toScanQRCodeVc() {
        self.pushVc(vc: ScanQrCodeViewController(), hideAll: true)
    }
    
    @objc func toMessageVc() {
        let vc = BaseTestViewController()
        self.pushVc(vc: vc, animate: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "FunctionListTableViewCell", tableView: tableView) as! FunctionListTableViewCell
        let item = self.tableViewData[indexPath.row]
        cell.setContent(data: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let tabbarVc = appDelegate.rootVc?.drawerVc.tabbarVc {
            return tabbarVc.tabBarHeight + tabbarVc.musicControlBarHeight
        }
        
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        return footer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let selectedRow = self.tableViewData[row]
        var targetController: UIViewController? = nil
        var hideAllTabBar = false
        switch selectedRow.id {
        case "1":
            targetController = PlayViewController()
        case "2":
            targetController = AnimationViewController()
        case "3":
            targetController = BezierPathViewController()
        case "4":
            targetController = TestTableViewController()
        case "5":
            targetController = Collection1ViewController()
        case "6":
            targetController = MapViewController()
        case "7":
            targetController = ModalViewController()
        case "8":
            targetController = SceneKitViewController()
        case "9":
            hideAllTabBar = true
            targetController = BaseWebViewController.create(with: "https://blog.iword.win")
//            let a: WebViewController = WebViewController()
//            a.url = "https://blog.iword.win"
//            targetController = a
        case "10":
            targetController = ScanQrCodeViewController()
            hideAllTabBar = true
        case "11":
            targetController = RecordViewController()
        case "12":
            if MusicService.shared.isPlaying && MusicService.shared.musicList.count > 1 {
                return
            }
            MusicService.shared.musicList = MockService.shared.getRandomMusic()
            appDelegate.musicWindow?.show()
            MusicService.shared.play()
            return
        case "13":
            targetController = ThreadViewController()
        case "14":
            targetController = CoreDataViewController()
        default:
            targetController = BaseTestViewController()
        }
        if let targetController = targetController {
            self.pushVc(vc: targetController, hideAll: hideAllTabBar)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("change edit")
        let text = searchBar.searchTextField.text ?? ""
        self.tableViewData = self.tableViewDataCopy.filter { (item) -> Bool in
            return text == "" ? true : item.name.uppercased().contains(text.uppercased())
        }
        self.tableView.reloadData()
    }
}
