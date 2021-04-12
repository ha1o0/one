//
//  BezierPathViewController.swift
//  one
//
//  Created by sidney on 4/12/21.
//

import UIKit

class BezierPathViewController: BaseViewController {

    lazy var scrollView = {
        return UIScrollView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "贝塞尔曲线"
        setCustomNav()
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = .lightGray
        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(navigationView.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }
    
    func setupBezierView1() {
        
    }
}
