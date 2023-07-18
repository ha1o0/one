//
//  CustomTabBarViewController.swift
//  one
//
//  Created by sidney on 6/9/21.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    var hasAllShow: Bool = true
    let blurDownHeight = 8.0
    var tabbarItems: [TabbarItem] = {
        var items: [TabbarItem] = []
        let item1 = TabbarItem(vc: HomeViewController(), title: "首页", imageName: "home", selectedImageName: "homeSelected")
        items.append(item1)
        let item2 = TabbarItem(vc: MusicHomeViewController(), title: "我的", imageName: "my", selectedImageName: "mySelected")
        items.append(item2)
        let item3 = TabbarItem(vc: OpenHomeViewController(), title: "开放", imageName: "open", selectedImageName: "openSelected")
        items.append(item3)
        return items
    }()
    var musicControlBarHeight: CGFloat = 50
    var animationDuration: TimeInterval = 0.4
    lazy var musicControlBar: MusicControlBar1 = {
        let _musicControlBar = viewFromNib("MusicControlBar1") as! MusicControlBar1
        return _musicControlBar
    }()
    
    var customTabBar: CustomTabBar = CustomTabBar()
    var bottomBlurView: UIVisualEffectView = {
        let _bottomBlurView = UIVisualEffectView(effect: UIBlurEffect(style: ThemeManager.shared.getBlurStyle()))
        return _bottomBlurView
    }()
    // 整个底部 bar 高度
    var tabBarHeight: CGFloat {
        get {
            // tabbar height + music bar height + extra
            return 49 + 50 + BOTTOM_EXTRA_HEIGHT
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        NotificationService.shared.listenInterfaceStyleChange(target: self, selector: #selector(switchBlurStyle))
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
            items.append(navVc)
        }
        self.viewControllers = items
        let frame = self.tabBar.frame
        self.tabBar.isHidden = true
        self.view.addSubview(bottomBlurView)
        self.bottomBlurView.snp.makeConstraints { (maker) in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.height.equalTo(self.tabBarHeight - self.blurDownHeight)
        }
        self.customTabBar = CustomTabBar(tabBarItems: self.tabbarItems, frame: frame, self.changeSelectedIndex)
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
        MusicService.shared.musicList = MockService.shared.getRandomMusic()
        self.view.insertSubview(musicControlBar, belowSubview: self.customTabBar)
        musicControlBar.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-(self.tabBarHeight - self.musicControlBarHeight))
            maker.height.equalTo(self.musicControlBarHeight)
        }
        musicControlBar.commonInit()
    }
    
    func showTabbar() {
        // 判断是否已经 show，show 了就不再 show
        if (self.hasAllShow) {
            return
        }
        UIView.animate(withDuration: self.animationDuration) {
            self.bottomBlurView.frame.origin.y = SCREEN_HEIGHT - self.tabBarHeight + self.blurDownHeight
            self.musicControlBar.frame.origin.y = SCREEN_HEIGHT - self.tabBarHeight
            self.customTabBar.frame.origin.y = SCREEN_HEIGHT - self.tabBarHeight + self.musicControlBarHeight
            self.customTabBar.showTabBarItems()
            self.hasAllShow = true
        }
    }

    func hideTabbar(_ all: Bool = false) {
        let hideAll = NotificationService.shared.hideAll || all
        UIView.animate(withDuration: self.animationDuration) {
            self.bottomBlurView.frame.origin.y = hideAll ? SCREEN_HEIGHT : SCREEN_HEIGHT - self.musicControlBarHeight - BOTTOM_EXTRA_HEIGHT + self.blurDownHeight
            self.musicControlBar.frame.origin.y = hideAll ? SCREEN_HEIGHT : SCREEN_HEIGHT - BOTTOM_EXTRA_HEIGHT - self.musicControlBarHeight
            self.customTabBar.frame.origin.y = hideAll ? SCREEN_HEIGHT : SCREEN_HEIGHT - BOTTOM_EXTRA_HEIGHT
            self.customTabBar.hideTabBarItems()
            self.hasAllShow = false
        }
    }
    
    @objc func switchBlurStyle() {
        let newBlurEffect = UIBlurEffect(style: ThemeManager.shared.getBlurStyle())
        self.bottomBlurView.effect = newBlurEffect
    }
    
    func hideBottom() {
        self.musicControlBar.isHidden = true
        self.customTabBar.isHidden = true
        self.bottomBlurView.isHidden = true
    }
    
    func showBottom() {
        self.musicControlBar.isHidden = false
        self.customTabBar.isHidden = false
        self.bottomBlurView.isHidden = false
    }
    
}
