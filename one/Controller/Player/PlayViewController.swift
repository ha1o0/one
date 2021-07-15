//
//  PlayViewController.swift
//  diyplayer
//
//  Created by sidney on 2018/8/26.
//  Copyright © 2018年 sidney. All rights reserved.
//

import UIKit
import SnapKit
import Dplayer
import AVKit

class PlayViewController: BaseViewController, DplayerDelegate {
    
    func beforeFullScreen() {
        appDelegate.rootVc?.drawerVc.tabbarVc?.hideBottom()
    }
    
    func fullScreen() {
        appDelegate.deviceOrientation = .landscapeRight
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func exitFullScreen() {
        appDelegate.deviceOrientation = .portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        appDelegate.rootVc?.drawerVc.tabbarVc?.showBottom()
        appDelegate.rootVc?.drawerVc.tabbarVc?.hideTabbar(true)
    }
    
    func pip() {
        pipController = self.diyPlayerView.getPipVc()
        pipController?.delegate = self
        self.diyPlayerView.startPip(pipController)
    }
    
    var pipController: AVPictureInPictureController?
    var vc: PlayViewController?
    var popForPip = false
    var diyPlayerView: DplayerView!
    var responseButton = UIButton()
    var domainName = UITextField()
    var videos = ["https://blog.iword.win/langjie.mp4", "http://192.168.6.242/2.mp4", "https://blog.iword.win/5.mp4", "http://192.168.6.242/3.wmv", "https://blog.iword.win/mjpg.avi", "https://iqiyi.cdn9-okzy.com/20201104/17638_8f3022ce/index.m3u8"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()
        diyPlayerView = DplayerView(frame: CGRect(x: 0, y: STATUS_BAR_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_WIDTH / 16 * 9))
        diyPlayerView.layer.zPosition = 999
        diyPlayerView.delegate = self
        diyPlayerView.bottomProgressBarViewColor = .main
        view.addSubview(diyPlayerView)
        diyPlayerView.playUrl(url: videos[0])
        setSeries()
    }
    
    func setSeries() {
        let seriesView = UIScrollView()
        seriesView.layer.zPosition = 998
        seriesView.contentSize = CGSize(width: 0, height: 34)
        seriesView.alwaysBounceVertical = false
        seriesView.alwaysBounceHorizontal = true
        view.addSubview(seriesView)
        seriesView.snp.makeConstraints { (maker) in
            maker.top.equalTo(diyPlayerView.snp.bottom).offset(20)
            maker.leading.equalToSuperview().offset(16)
            maker.trailing.equalToSuperview().offset(-16)
            maker.height.equalTo(50)
        }
        for (index, _) in videos.enumerated() {
            let button = UIButton()
            let width = 100
            button.setTitleColor(UIColor.main, for: .normal)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
            button.layer.borderColor = UIColor.main.cgColor
            button.setTitle("第\(index + 1)集", for: .normal)
            button.tag = index
            seriesView.addSubview(button)
            button.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview()
                maker.leading.equalToSuperview().offset((width + 20) * index)
                maker.width.equalTo(width)
            }
            seriesView.contentSize.width += CGFloat((width + 20))
            button.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        }
        seriesView.contentSize.width -= 20
    }
    
    @objc func playVideo(target: UIButton) {
        diyPlayerView.playUrl(url: videos[target.tag])
    }
    
    func setDomainView() {
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
        appDelegate.rootVc?.drawerVc.tabbarVc?.hideTabbar(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.popForPip {
            return
        }
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

extension PlayViewController: AVPictureInPictureControllerDelegate {
    // 保持当前VC不被销毁
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        self.vc = self
        self.popForPip = true
        self.navigationController?.popViewController(animated: true)
    }

    // 销毁原VC，push新VC
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        self.vc = nil
        if let topVc = getTopViewController() {
            topVc.navigationController?.pushViewController(PlayViewController(), animated: true)
        }
        print("pictureInPictureControllerDidStopPictureInPicture")
    }
}
