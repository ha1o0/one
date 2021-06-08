//
//  BaseViewController.swift
//  one
//
//  Created by sidney on 2021/3/20.
//

import UIKit

enum VcEnterType {
    case push
    case present
}

class BaseViewController: UIViewController {
    
    var showStatusBar = true
    var showNavBar = true
    var isTabBarVc = false
    var enterType: VcEnterType = .push
    lazy var statusBarView = UIView()
    lazy var navigationView = UIView()
    
    class func create() -> BaseViewController {
        let vc = BaseViewController()
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setStatusBar(color: UIColor = UIColor.main) {
        view.addSubview(statusBarView)
        statusBarView.backgroundColor = color
        statusBarView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.height.equalTo(STATUS_BAR_HEIGHT)
        }
    }
    
    func setCustomNav(color: UIColor = UIColor.main) {
        setStatusBar(color: color)
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (maker) in
            maker.top.equalTo(statusBarView.snp.bottom)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(44)
        }
        navigationView.backgroundColor = color
        let leftView = UIView()
        navigationView.addSubview(leftView)
        leftView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(0)
            maker.width.equalTo(80)
            maker.height.equalTo(44)
        }
        let leftArrowImageView = UIImageView()
        leftArrowImageView.image = UIImage(named: "back")
        leftView.addSubview(leftArrowImageView)
        leftArrowImageView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.width.equalTo(36)
            maker.height.equalTo(28)
            maker.leading.equalToSuperview().offset(8)
        }
        leftArrowImageView.isUserInteractionEnabled = true
        let backRecognizer = UITapGestureRecognizer(target: self, action: #selector(back))
        leftArrowImageView.addGestureRecognizer(backRecognizer)
        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .white
            navigationView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (maker) in
                maker.center.equalToSuperview()
            }
        }
    }
    
    func setNavigation() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.clear // 如果设置了颜色，顶部的Nav Bar就会显示对应的颜色
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    @objc func back() {
        if enterType == .push {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    deinit {
        print("---deinit---:\(self)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("收到了内存警告:\(self)")
    }
}

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func pushVc(vc: UIViewController, animate: Bool = true) {
        // 解决新vc与tab vc的tabbar显示与否的问题
//        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: animate)
//        self.hidesBottomBarWhenPushed = false
    }
}

