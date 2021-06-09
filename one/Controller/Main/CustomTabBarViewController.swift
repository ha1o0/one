//
//  CustomTabBarViewController.swift
//  one
//
//  Created by sidney on 6/9/21.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    var tabbarItems: [TabbarItem] = {
        var items: [TabbarItem] = []
        let item1 = TabbarItem(vc: HomeViewController(), title: "首页", imageName: "home", selectedImageName: "homeSelected")
        items.append(item1)
        let item2 = TabbarItem(vc: MusicHomeViewController(), title: "我的", imageName: "my", selectedImageName: "mySelected")
        items.append(item2)
        return items
    }()
    var musicControlBarHeight: CGFloat = 50
    var animationDuration: TimeInterval = 0.4
    lazy var musicControlBar: MusicControlBar = {
        let _musicControlBar = viewFromNib("MusicControlBar") as! MusicControlBar
        return _musicControlBar
    }()
    
    var customTabBar: CustomTabBar = CustomTabBar()
    var tabBarHeight: CGFloat {
        get {
            return self.tabBar.frame.size.height
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("tabbar didappear")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setup() {
        var items: [BaseNavigationViewController] = []
        for barItem in tabbarItems {
            let navVc = BaseNavigationViewController(rootViewController: barItem.vc)
            navVc.navigationBar.isHidden = true
            navVc.tabBarItem.title = barItem.title
            navVc.tabBarItem.image = UIImage(named: barItem.imageName)?.withRenderingMode(.alwaysOriginal)
            navVc.tabBarItem.selectedImage = UIImage(named: barItem.selectedImageName)?.withRenderingMode(.alwaysOriginal)
            items.append(navVc)
        }
        self.viewControllers = items
        let frame = self.tabBar.frame
        self.tabBar.isHidden = true
        self.customTabBar = CustomTabBar(tabBarItems: self.tabbarItems, frame: frame)
        self.customTabBar.selectTabCallback = self.changeSelectedIndex
        self.view.addSubview(self.customTabBar)
        self.customTabBar.snp.makeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.height.equalTo(49 + (hasNotch ? 34 : 0))
        }
        self.setupMusicControlBar()
        self.view.layoutIfNeeded()
    }

    func changeSelectedIndex(index: Int) {
        self.selectedIndex = index
    }
    
    func setupMusicControlBar() {
        let bottomTabBarHeight = tabBarHeight + (hasNotch ? 34 : 0)
        MusicService.shared.musicList = MockService.shared.getRandomMusic()
        musicControlBar.frame = CGRect(x: 0, y: SCREEN_HEIGHT - bottomTabBarHeight, width: SCREEN_WIDTH, height: self.musicControlBarHeight)
        self.view.insertSubview(musicControlBar, belowSubview: self.customTabBar)
        musicControlBar.commonInit()
    }
    
    func showTabbar() {
        UIView.animate(withDuration: self.animationDuration) {
            self.musicControlBar.center.y = SCREEN_HEIGHT - self.tabBarHeight - self.musicControlBarHeight / 2
            self.customTabBar.center.y = SCREEN_HEIGHT - self.tabBarHeight / 2
            self.customTabBar.showTabBarItems()
        }
    }

    func hideTabbar() {
        let extraBottomHeight: CGFloat = hasNotch ? 34 : 0
        UIView.animate(withDuration: self.animationDuration) {
            self.musicControlBar.frame.origin.y = SCREEN_HEIGHT - extraBottomHeight - self.musicControlBarHeight
            self.customTabBar.frame.origin.y = SCREEN_HEIGHT - extraBottomHeight
            self.customTabBar.hideTabBarItems()
        }
    }
    
    func switchBlurStyle() {
//        if ThemeManager.shared.currentInterfaceStyle == .light {
//            ThemeManager.shared.currentInterfaceStyle = .dark
//        } else {
//            ThemeManager.shared.currentInterfaceStyle = .light
//        }
        
        let newBlurEffect = UIBlurEffect(style: ThemeManager.shared.getBlurStyle())
        self.musicControlBar.visualEffectView.effect = newBlurEffect
        self.customTabBar.blurView.effect = newBlurEffect
        self.customTabBar.updateTabBarItems(colors: ThemeManager.shared.getBarColor())
    }
}
