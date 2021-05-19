//
//  TabBarViewController.swift
//  one
//
//  Created by sidney on 5/10/21.
//

import UIKit

class TabBarViewController: UITabBarController {

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
        
        let testController = BaseTestViewController()
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
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.white
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
