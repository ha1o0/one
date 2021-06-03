//
//  TabBarViewController.swift
//  one
//
//  Created by sidney on 5/10/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    var defaultBlurStyles: [UIBlurEffect.Style] = [.extraLight, .dark]
    var currentBlurStyleIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("tabbar didload")
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("tabbar didappear")
        // 隐藏顶部导航bar，不能放在didload中
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setup() {
        let homeController = HomeViewController()
        let homeNavigationVc = BaseNavigationViewController(rootViewController: homeController)
        homeNavigationVc.navigationBar.isHidden = true
        homeNavigationVc.tabBarItem.title = "首页"
        homeNavigationVc.tabBarItem.image = UIImage(named: "home")
        homeNavigationVc.tabBarItem.selectedImage = UIImage(named: "homeSelected")
        
        let testController = MusicHomeViewController()
        let testNavigationVc = BaseNavigationViewController(rootViewController: testController)
        testNavigationVc.navigationBar.isHidden = true
        testNavigationVc.tabBarItem.title = "我的"
        testNavigationVc.tabBarItem.image = UIImage(named: "my")
        testNavigationVc.tabBarItem.selectedImage = UIImage(named: "mySelected")
        
        let items = [homeNavigationVc, testNavigationVc]
        for item in items {
            item.tabBarItem.selectedImage = item.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
            item.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.main], for: .selected)
            item.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.tabBarGray], for: .normal)
        }
        
        self.viewControllers = items
        self.setTabbar()
    }
    
    func setTabbar() {
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.barTintColor = .clear
        tabBar.backgroundColor = .clear
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
        let blurView = getBlurView(style: defaultBlurStyles[currentBlurStyleIndex])
        blurView.frame = self.tabBar.bounds
        tabBar.insertSubview(blurView, at: 0)
    }
    
    func getBlurView(style: UIBlurEffect.Style) -> UIVisualEffectView {
        let _blurEffect = UIBlurEffect(style: style)
        let _blurView = UIVisualEffectView(effect: _blurEffect)
        _blurView.autoresizingMask = .flexibleHeight
        return _blurView
    }
    
    func removeBlurView() {
        for subview in tabBar.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    func switchBlurStyle() {
        let defaultTotalStyleCount = defaultBlurStyles.count
        currentBlurStyleIndex += 1
        if currentBlurStyleIndex == defaultTotalStyleCount {
            currentBlurStyleIndex = 0
        }
        setBlurForTabbar(style: defaultBlurStyles[currentBlurStyleIndex])
    }
    
    func setBlurForTabbar(style: UIBlurEffect.Style) {
        let blurView = getBlurView(style: style)
        blurView.frame = self.tabBar.bounds
        self.removeBlurView()
        tabBar.insertSubview(blurView, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("tabbar willappear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        print("tabbar willdisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        print("tabbar diddisappear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        print("tabbar willlayoutsubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("tabbar didlayoutsubviews")
    }
    
}
