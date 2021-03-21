//
//  PlayViewController.swift
//  diyplayer
//
//  Created by sidney on 2018/8/26.
//  Copyright © 2018年 sidney. All rights reserved.
//

import UIKit
import SnapKit

class PlayViewController: BaseViewController {

    var diyPlayerView = DiyPlayerView()
    var responseButton = UIButton()
    var domainName = UITextField()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        diyPlayerView = DiyPlayerView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 250))
        diyPlayerView.commonInit()
        self.view.addSubview(diyPlayerView)
        
        // input domain
        let uiInputView = UIView()
        uiInputView.backgroundColor = UIColor.gray
        self.view.addSubview(uiInputView)
        uiInputView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(0)
            maker.trailing.equalToSuperview().offset(0)
            maker.top.equalTo(diyPlayerView.snp.bottom).offset(20)
            maker.height.equalTo(50)
        }
        uiInputView.addSubview(self.domainName)
        self.domainName.snp.makeConstraints { (maker) in
            maker.height.equalTo(40)
            maker.width.equalTo(350)
            maker.center.equalToSuperview()
        }
        self.domainName.placeholder = "json.cn"
        self.domainName.text = "json.cn"
        // query button
        let uiView = UIView()
        uiView.backgroundColor = UIColor.gray
        self.view.addSubview(uiView)
        uiView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(0)
            maker.trailing.equalToSuperview().offset(0)
            maker.top.equalTo(uiInputView.snp.bottom).offset(20)
            maker.height.equalTo(50)
        }
        let requestBtn = UIButton()
        requestBtn.setTitle("查询域名信息", for: .normal)
        requestBtn.setTitleColor(UIColor.white, for: .normal)
        requestBtn.setTitleColor(UIColor.blue, for: .highlighted)
        uiView.addSubview(requestBtn)
        requestBtn.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        requestBtn.addTarget(self, action: #selector(getNetData), for: .touchUpInside)
        
        // response
        let uiResponseView = UIView()
        uiResponseView.backgroundColor = UIColor.gray
        self.view.addSubview(uiResponseView)
        uiResponseView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(0)
            maker.trailing.equalToSuperview().offset(0)
            maker.top.equalTo(uiView.snp.bottom).offset(20)
            maker.height.equalTo(50)
        }
        responseButton.setTitleColor(UIColor.white, for: .normal)
        uiResponseView.addSubview(responseButton)
        responseButton.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.diyPlayerView.closePlayer()
    }

    @objc func getNetData() {
//        let domain = self.domainName.text ?? "json.cn"
//        let url = "https://www.sojson.com/api/beian/\(domain)"
//        Alamofire.request(url, method: .get).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("JSON: \(json)")
//                let nowIcp = json["nowIcp"].stringValue
//                let name = json["name"].stringValue
//                let result = name == "" ? json["message"].stringValue : "\(name),\(nowIcp)"
//                self.responseButton.setTitle(result, for: .normal)
//
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
