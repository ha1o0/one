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

class TabBarViewController: UITabBarController {

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
    
    lazy var musicControlBar: MusicControlBar = {
        let _musicControlBar = viewFromNib("MusicControlBar") as! MusicControlBar
        return _musicControlBar
    }()
    
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

        let colors = defaultBarColors[currentBlurStyleIndex]
        setTabbarColor(colors: colors)
        self.viewControllers = items
        self.setTabbar()
        MusicService.shared.musicList = MockService.shared.getRandomMusic()
        self.musicControlBar.alpha = 0
        self.view.addSubview(musicControlBar)
        musicControlBar.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(self.tabBar.snp.top)
            maker.height.equalTo(50)
        }
        musicControlBar.commonInit()
        UIView.animate(withDuration: 1, delay: 5) {
            self.musicControlBar.alpha = 1
        }
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
//        print("tabbar willlayoutsubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("tabbar didlayoutsubviews")
    }
    
}
