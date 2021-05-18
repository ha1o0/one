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
    
    lazy var contentView: UIView = {
        let _contentView = UIView()
        _contentView.backgroundColor = .white
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
        usernameLabel.font = UIFont.systemFont(ofSize: 15)
        _topBarView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(avatarView.snp.trailing).offset(20)
        }
        let scanIcon = UIButton.getSystemIconBtn(name: "camera.metering.none", color: .black)
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
        _tableView.backgroundColor = .lightText
        _tableView.separatorStyle = .none
        return _tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print("leftdrawvc didload")
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
    }
    
    @objc func toScanQRCodeVc() {
//        self.pushVc(vc: ScanQrCodeViewController())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = data[section].items
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "FunctionListTableViewCell", tableView: tableView) as! FunctionListTableViewCell
        let item = self.data[indexPath.section].items[indexPath.row]
        let contentItem = IdName(name: item.name, id: "")
        cell.setContent(data: contentItem)
        
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
        }
        return uiview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 160
        }
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let uiview = UIView()
        uiview.backgroundColor = .red
        return uiview
    }
}
