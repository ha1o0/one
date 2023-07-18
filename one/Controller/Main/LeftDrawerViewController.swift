//
//  LeftDrawerViewController.swift
//  one
//
//  Created by sidney on 5/11/21.
//

import UIKit

class LeftDrawerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let leftVcVisibleViewWidth: CGFloat = CGFloat(SCREEN_WIDTH * leftVcleftVcVisibleViewWidthPercent)
    var data: [LeftDrawerSection] = []
    var panGesture: UIPanGestureRecognizer!
    var hasOpenLeftVc = false
    weak var drawVc: DrawerViewController?
    
    lazy var contentView: UIView = {
        let _contentView = UIView()
        _contentView.backgroundColor = .clear
        _contentView.frame = CGRect(x: SCREEN_WIDTH - leftVcVisibleViewWidth, y: 0, width: leftVcVisibleViewWidth, height: SCREEN_HEIGHT)
        return _contentView
    }()
    
    var topBarView: UIView = {
        let _topBarView = UIView()
        let avatarView = UIImageView()
        let avatarUrl = "http://b-ssl.duitang.com/uploads/item/201809/24/20180924092018_zjgut.jpg"
        avatarView.loadFrom(link: avatarUrl, isCircle: true)
        _topBarView.addSubview(avatarView)
        avatarView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(0)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(33)
            maker.height.equalTo(33)
        }
        let usernameLabel = UILabel()
        usernameLabel.text = "炒饭冷面河粉"
        usernameLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 500))
        usernameLabel.textColor = .label
        _topBarView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(avatarView.snp.trailing).offset(20)
        }
        let scanIcon = UIButton.getSystemIconBtn(name: "camera.metering.none", color: .label)
        _topBarView.addSubview(scanIcon)
        scanIcon.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(0)
        }
        scanIcon.addTarget(self, action: #selector(toScanQRCodeVc), for: .touchUpInside)
        return _topBarView
    }()
    
    lazy var tableView: UITableView = {
        let _tableView = UITableView()
        if #available(iOS 15.0, *) {
           _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.backgroundColor = .clear
        _tableView.separatorStyle = .none
        return _tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("leftdrawvc didload")
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeView))
        NotificationService.shared.listenInterfaceStyleChange(target: self, selector: #selector(changeInterfaceStyle))
    }
    
    func setup() {
        self.view.addSubview(contentView)
        self.contentView.addSubview(topBarView)
        topBarView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(STATUS_BAR_HEIGHT)
            maker.leading.equalToSuperview().offset(15)
            maker.trailing.equalToSuperview().offset(-15)
            maker.height.equalTo(50)
        }
        
        self.contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(topBarView.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        let section1 = LeftDrawerSection()
        data.append(section1)
        var section2 = LeftDrawerSection()
        section2.items.append(LeftDrawerItem(name: "消息中心", iconName: "mail", hasSwitch: false, subInfo: ""))
        section2.items.append(LeftDrawerItem(name: "位置中心", iconName: "mark", hasSwitch: false, subInfo: ""))
        section2.items.append(LeftDrawerItem(name: "订单中心", iconName: "wallet", hasSwitch: false, subInfo: ""))
        data.append(section2)
        var section3 = LeftDrawerSection()
        section3.title = "其他设置"
        section3.items.append(LeftDrawerItem(name: "设置", iconName: "mail", hasSwitch: false, subInfo: ""))
        section3.items.append(LeftDrawerItem(name: "夜间模式", iconName: "mark", hasSwitch: true, subInfo: ""))
        section3.items.append(LeftDrawerItem(name: "定时关闭", iconName: "wallet", hasSwitch: false, subInfo: ""))
        section3.items.append(LeftDrawerItem(name: "黑名单", iconName: "mail", hasSwitch: false, subInfo: ""))
        section3.items.append(LeftDrawerItem(name: "个性", iconName: "mark", hasSwitch: false, subInfo: ""))
        section3.items.append(LeftDrawerItem(name: "闹钟", iconName: "wallet", hasSwitch: false, subInfo: ""))
        data.append(section3)
        
        var section4 = LeftDrawerSection()
        section4.items.append(LeftDrawerItem(name: "我的客服", iconName: "mail", hasSwitch: false, subInfo: ""))
        section4.items.append(LeftDrawerItem(name: "分享此应用", iconName: "mark", hasSwitch: false, subInfo: ""))
        section4.items.append(LeftDrawerItem(name: "关于", iconName: "wallet", hasSwitch: false, subInfo: ""))
        data.append(section4)
        
//        var section5 = LeftDrawerSection()
//        section5.items.append(LeftDrawerItem(name: "退出", iconName: "mail", hasSwitch: false, subInfo: ""))
//        data.append(section5)
    }
    
    func addGesture() {
        self.removeGesture()
        self.contentView.addGestureRecognizer(panGesture)
    }
    
    func removeGesture() {
        self.contentView.removeGestureRecognizer(panGesture)
    }
    
    @objc func swipeView(sender: UIPanGestureRecognizer) {
        guard let drawVc = drawVc else {
            return
        }
        let distance = sender.translation(in: contentView)
        if sender.state == .ended || sender.state == .cancelled {
            if distance.x > -50 {
                drawVc.openLeftVc()
            } else {
                drawVc.closeLeftVc()
            }
            return
        }
        drawVc.shadowView.alpha = CGFloat(drawVc.shadowAlpha) + min(CGFloat(drawVc.shadowAlpha / drawVc.leftVcVisibleViewWidth) * distance.x, 0)
        self.view.frame.origin.x = -SCREEN_WIDTH + leftVcVisibleViewWidth + min(distance.x, 0)
        
    }
    
    @objc func toScanQRCodeVc() {
        NotificationService.shared.gotoVc(ScanQrCodeViewController(), true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = data[section].items
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "LeftDrawerTableViewCell", tableView: tableView) as! LeftDrawerTableViewCell
        let currentSectionItems = self.data[indexPath.section].items
        let item = currentSectionItems[indexPath.row]
        cell.selectionStyle = .none
        cell.setContent(item: item, isFirst: indexPath.row == 0 && !sectionHasHeader(section: indexPath.section), isLast: indexPath.row == currentSectionItems.count - 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let uiview = UIView()
        if section == 0 {
            let card = viewFromNib("MemberCardView")
            uiview.addSubview(card)
            card.snp.makeConstraints { (maker) in
                maker.top.bottom.equalToSuperview()
                maker.leading.equalToSuperview().offset(15)
                maker.width.equalTo(leftVcVisibleViewWidth - 30)
            }
        } else {
            let contentView = UIView()
            uiview.addSubview(contentView)
            contentView.snp.makeConstraints { (maker) in
                maker.leading.equalToSuperview().offset(15)
                maker.width.equalTo(leftVcVisibleViewWidth - 30)
                maker.top.bottom.equalToSuperview()
            }
            contentView.layer.cornerRadius = 10
            contentView.layer.masksToBounds = true
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            contentView.backgroundColor = .systemGray6
            
            let title = UILabel()
            title.text = data[section].title
            title.textColor = .gray
            title.font = UIFont.systemFont(ofSize: 12)
            contentView.addSubview(title)
            title.snp.makeConstraints { (maker) in
                maker.centerY.equalToSuperview()
                maker.leading.equalToSuperview().offset(15)
            }
            
            let splitView = UIView()
            splitView.backgroundColor = .systemGray5
            contentView.addSubview(splitView)
            splitView.snp.makeConstraints { (maker) in
                maker.height.equalTo(1)
                maker.leading.trailing.bottom.equalToSuperview()
            }
        }
        return uiview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 160
        }
        return sectionHasHeader(section: section) ? 40 : .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let uiview = UIView()
        uiview.backgroundColor = .clear
        return uiview
    }
    
    func sectionHasHeader(section: Int) -> Bool {
        return data[section].title != ""
    }
    
    @objc func changeInterfaceStyle() {
        self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
}
