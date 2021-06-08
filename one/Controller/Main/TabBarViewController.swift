//
//  TabBarViewController.swift
//  one
//
//  Created by sidney on 5/10/21.
//

import UIKit

struct TabbarItem {
    var vc: UIViewController
    var title = ""
    var imageName = ""
    var selectedImageName = ""
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    var defaultBlurStyles: [UIBlurEffect.Style] = [.extraLight, .dark]
    var defaultBarColors: [[UIColor]] = [[UIColor.main, UIColor.tabBarGray], [UIColor.white, UIColor.tabBarGray]]
    var currentBlurStyleIndex: Int = 0
    var tabbarItems: [TabbarItem] = {
        var items: [TabbarItem] = []
        let item1 = TabbarItem(vc: HomeViewController(), title: "首页", imageName: "home", selectedImageName: "homeSelected")
        items.append(item1)
        let item2 = TabbarItem(vc: MusicHomeViewController(), title: "我的", imageName: "my", selectedImageName: "mySelected")
        items.append(item2)
        return items
    }()
    var musicControlBarHeight: CGFloat = 50
    var animationDuration: TimeInterval = 0.6
    lazy var musicControlBar: MusicControlBar = {
        let _musicControlBar = viewFromNib("MusicControlBar") as! MusicControlBar
        return _musicControlBar
    }()
    
    var tabBarHeight: CGFloat {
        get {
            return self.tabBar.frame.size.height
        }
    }
    
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
        var items: [BaseNavigationViewController] = []
        for barItem in tabbarItems {
            let navVc = BaseNavigationViewController(rootViewController: barItem.vc)
            navVc.navigationBar.isHidden = true
            navVc.tabBarItem.title = barItem.title
            navVc.tabBarItem.image = UIImage(named: barItem.imageName)
            navVc.tabBarItem.selectedImage = UIImage(named: barItem.selectedImageName)
            items.append(navVc)
        }
        self.viewControllers = items
        MusicService.shared.musicList = MockService.shared.getRandomMusic()
        self.view.insertSubview(musicControlBar, belowSubview: self.tabBar)
        let bottomTabBarHeight = tabBarHeight + (hasNotch ? 34 : 0)
        let bottomMusicBarHeight = bottomTabBarHeight + musicControlBarHeight
        musicControlBar.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().offset(bottomMusicBarHeight)
            maker.height.equalTo(bottomMusicBarHeight)
        }
        musicControlBar.commonInit()
        self.setTabbar()
        let colors = defaultBarColors[currentBlurStyleIndex]
        setTabbarColor(colors: colors)
    }
    
    func hideMusicControlBar() {
        UIView.animate(withDuration: animationDuration) {
            self.musicControlBar.frame.origin.y = SCREEN_HEIGHT
        }
    }
    
    func showMusicControlBar() {
        UIView.animate(withDuration: animationDuration) {
            self.musicControlBar.frame.origin.y = SCREEN_HEIGHT - self.tabBarHeight - self.musicControlBarHeight
        }
    }
    
    func showTabbar() {
        UIView.animate(withDuration: animationDuration) {
            self.tabBar.frame.origin.y = SCREEN_HEIGHT - self.tabBarHeight
            self.musicControlBar.frame.origin.y = SCREEN_HEIGHT - self.tabBarHeight - self.musicControlBarHeight
        }
    }
    
    func hideTabbar() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.tabBar.frame.origin.y = SCREEN_HEIGHT
            self.musicControlBar.frame.origin.y = SCREEN_HEIGHT - self.tabBarHeight
        })
    }
    
    func setTabbar() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.barTintColor = .clear
        tabBar.backgroundColor = .clear
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
//        let blurView = getBlurView(style: defaultBlurStyles[currentBlurStyleIndex])
//        blurView.frame = self.tabBar.bounds
//        tabBar.insertSubview(blurView, at: 0)
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
        setTabbarColor(colors: defaultBarColors[currentBlurStyleIndex])
    }
    
    func setBlurForTabbar(style: UIBlurEffect.Style) {
        let blurView = getBlurView(style: style)
        blurView.frame = self.tabBar.bounds
        self.removeBlurView()
        tabBar.insertSubview(blurView, at: 0)
    }
    
    func setTabbarColor(colors: [UIColor]) {
        guard let items = self.viewControllers else {
            return
        }
        for (index, item) in items.enumerated() {
            let barItem = tabbarItems[index]
            item.tabBarItem.selectedImage = UIImage(named: colors[0] == UIColor.white ? barItem.imageName : barItem.selectedImageName)
            item.tabBarItem.selectedImage = item.tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
            item.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors[0]], for: .selected)
            item.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: colors[1]], for: .normal)
        }
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
        print("tabbar willlayoutsubviews")
//        var tabFrame = self.tabBar.frame
//        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
//        tabFrame.origin.y = SCREEN_HEIGHT
//        self.tabBar.frame = tabFrame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("tabbar didlayoutsubviews")
    }
    
}
