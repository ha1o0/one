//
//  RecordViewController.swift
//  one
//
//  Created by sidney on 2021/9/11.
//

import UIKit
import AVFoundation

class RecordViewController: BaseViewController {

    lazy var startBtn: UIButton = {
        var _startBtn = UIButton()
        _startBtn.setTitle("开始录音", for: .normal)
        _startBtn.setTitleColor(.main, for: .normal)
        return _startBtn
    }()
    
    lazy var endBtn: UIButton = {
        var _endBtn = UIButton()
        _endBtn.setTitle("停止录音", for: .normal)
        _endBtn.setTitleColor(.red, for: .normal)
        return _endBtn
    }()
    
    lazy var timeLabel: UILabel = {
        var _timeLabel = UILabel()
        _timeLabel.textColor = .label
        _timeLabel.text = "00:00"
        return _timeLabel
    }()
    
    lazy var playBtn: UIButton = {
        var _playBtn = UIButton()
        _playBtn.isHidden = true
        _playBtn.setTitle("播放录音", for: .normal)
        _playBtn.setTitleColor(.yellow, for: .normal)
        return _playBtn
    }()
    
    var timer: Timer?
    var second = 0
    var recordUrlStr: String? {
        didSet {
            self.playBtn.isHidden = recordUrlStr == ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "录音"
        setCustomNav()
        setup()
    }
    
    func setup() {
        self.view.addSubview(self.startBtn)
        startBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.navigationView.snp.bottom).offset(40)
        }
        startBtn.addTarget(self, action: #selector(startRecord), for: .touchUpInside)
        self.view.addSubview(self.endBtn)
        endBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.navigationView.snp.bottom).offset(80)
        }
        endBtn.addTarget(self, action: #selector(endRecord), for: .touchUpInside)
        self.view.addSubview(self.timeLabel)
        timeLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.navigationView.snp.bottom).offset(150)
        }
        playBtn.addTarget(self, action: #selector(playRecord), for: .touchUpInside)
        self.view.addSubview(self.playBtn)
        playBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.navigationView.snp.bottom).offset(200)
        }
    }

    @objc func startRecord() {
        self.recordUrlStr = ""
        if (timer != nil) {
            return
        }
        self.second = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.second += 1
            self.timeLabel.text = TimeUtil.getTimeBySeconds(self.second)
        })
        RecordService.shared.startRecord(view: self.view, fileName: Date().timeStamp)
    }
    
    @objc func endRecord() {
        self.timer?.invalidate()
        self.timer = nil
        guard let url = RecordService.shared.stopRecord() else {
            return
        }
        let alertVc = UIAlertController(title: "保存录音", message: "请输入文件名", preferredStyle: .alert)
        alertVc.addTextField { (textField) in
            textField.placeholder = "文件名"
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确认", style: .default) { (action) in
            guard let fileName = alertVc.textFields?.first?.text else {
                self.recordUrlStr = url.absoluteString
                return
            }
            if fileName == "" {
                self.recordUrlStr = url.absoluteString
                return
            }
            do {
                let newUrl = RecordService.shared.getFileUrl(name: "\(fileName).wav")
                try FileManager.default.moveItem(at: url, to: newUrl)
                self.recordUrlStr = newUrl.absoluteString
            } catch let error {
                print(error)
            }
        }
        alertVc.addAction(cancelAction)
        alertVc.addAction(okAction)
        self.present(alertVc, animated: true, completion: nil)
        
    }
    
    @objc func playRecord() {
        guard let url = self.recordUrlStr else {
            return
        }
        let music = Music(id: Date().timeStamp, poster: MockService.shared.getRandomImg(), name: "录音", subtitle: "....", playCount: 1, author: "system", url: url, isLocal: false, type: "wav", duration: 0 )
        MusicService.shared.musicList = [music]
        MusicService.shared.play()
    }
}
