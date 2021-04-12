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
    lazy var contentView = UIView()
    lazy var firstView = UIView()
    lazy var secondView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "贝塞尔曲线"
        setCustomNav()
        initScrollContentView()
        setupBezierView1()
        setupBezierView2()
        // Do any additional setup after loading the view.
    }
    
    func initScrollContentView() {
        self.view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalTo(navigationView.snp.bottom)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.trailing.equalTo(self.view)
        }
    }
    
    func setupBezierView1() {
        contentView.addSubview(firstView)
        firstView.backgroundColor = .lightGray
        let height = CGFloat(600)
        firstView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalToSuperview()
            maker.height.equalTo(height)
        }
    }
    
    func setupBezierView2() {
        contentView.addSubview(secondView)
        secondView.backgroundColor = .lightText
        let height = CGFloat(600)
        secondView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(firstView.snp.bottom)
            maker.height.equalTo(height)
            maker.bottom.equalToSuperview()
        }
    }
}
