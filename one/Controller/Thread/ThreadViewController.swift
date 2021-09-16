//
//  ThreadViewController.swift
//  one
//
//  Created by sidney on 2021/9/16.
//

import UIKit

class ThreadViewController: BaseViewController {

    lazy var thread1Btn: UIButton = {
        var _startBtn = UIButton()
        _startBtn.setTitle("开始线程1", for: .normal)
        _startBtn.setTitleColor(.main, for: .normal)
        return _startBtn
    }()
    
    lazy var thread2Btn: UIButton = {
        var _startBtn = UIButton()
        _startBtn.setTitle("开始线程2", for: .normal)
        _startBtn.setTitleColor(.main, for: .normal)
        return _startBtn
    }()
    
    var param1 = 0
    var flag = true
    var timer: Timer?
    var seconds = 0
    var lock = NSLock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "多线程"
        setCustomNav()
        setup()
    }
    
    func setup() {
        self.view.addSubview(thread1Btn)
        thread1Btn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.navigationView.snp.bottom).offset(40)
        }
        thread1Btn.addTarget(self, action: #selector(startThread1), for: .touchUpInside)
        self.view.addSubview(thread2Btn)
        thread2Btn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(self.navigationView.snp.bottom).offset(80)
        }
        thread2Btn.addTarget(self, action: #selector(startThread2), for: .touchUpInside)
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (_) in
            ThreadService.shared.log()
        })
    }
    
    @objc func startThread1() {
        ThreadService.shared.thread1()
    }
    
    @objc func startThread2() {
        ThreadService.shared.thread2()
    }
}
