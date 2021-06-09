//
//  CustomTabBar.swift
//  one
//
//  Created by sidney on 6/9/21.
//

import Foundation
import UIKit

struct TabbarItem {
    var vc: UIViewController
    var title = ""
    var imageName = ""
    var selectedImageName = ""
}

class CustomTabBar: UIView {

    var selectedIndex: Int = 0
    var musicControlBarHeight: CGFloat = 50
    var animationDuration: TimeInterval = 0.3
    var tabBarItems: [TabbarItem] = []
    var selectTabCallback: ((_ index: Int) -> Void)?

    lazy var contentView: UIView = {
        let _contentView: UIView = UIView()
        return _contentView
    }()
    
    lazy var blurView: UIVisualEffectView = UIVisualEffectView()
    
    lazy var tabBarItemStackView: UIStackView = {
        let _stackView: UIStackView = UIStackView()
        _stackView.alignment = .center
        _stackView.distribution = .fillEqually
        _stackView.axis = .horizontal
        return _stackView
    }()
    
    lazy var musicControlBar: MusicControlBar = {
        let _musicControlBar = viewFromNib("MusicControlBar") as! MusicControlBar
        return _musicControlBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(tabBarItems: [TabbarItem], frame: CGRect) {
        self.init(frame: frame)
        self.tabBarItems = tabBarItems
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = .clear
        self.addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.setBlurForTabbar(style: ThemeManager.shared.getBlurStyle())
        
        contentView.addSubview(self.tabBarItemStackView)
        tabBarItemStackView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(2)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(49)
        }
        for (index, tabBarItem) in self.tabBarItems.enumerated() {
            let textColor = index == selectedIndex ? UIColor.main : UIColor.gray
            let tabBarItemView = UIView()
            let iconImage = UIImage(named: index == selectedIndex ? tabBarItem.selectedImageName : tabBarItem.imageName)?.withRenderingMode(.alwaysTemplate)
            let iconImageView = UIImageView(image: iconImage)
            iconImageView.tintColor = textColor
            tabBarItemView.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { maker in
                maker.width.height.equalTo(30)
                maker.top.equalToSuperview()
                maker.centerX.equalToSuperview()
            }
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 12)
            titleLabel.text = tabBarItem.title
            titleLabel.textColor = textColor
            tabBarItemView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { maker in
                maker.centerX.equalToSuperview()
                maker.top.equalTo(iconImageView.snp.bottom).offset(2)
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectTab(recognizer:)))
            tabBarItemView.tag = index
            tabBarItemView.isUserInteractionEnabled = true
            tabBarItemView.addGestureRecognizer(tapGesture)
            self.tabBarItemStackView.addArrangedSubview(tabBarItemView)
            tabBarItemView.snp.makeConstraints { maker in
                maker.centerY.equalToSuperview()
                maker.top.bottom.equalToSuperview()
            }
        }
        
    }
    
    @objc func selectTab(recognizer: UITapGestureRecognizer) {
        guard let recognizerView = recognizer.view else {
            return
        }
        self.selectedIndex = recognizerView.tag
        self.updateTabBarItems(colors: ThemeManager.shared.getBarColor())
        if let selectTabCallback = selectTabCallback {
            selectTabCallback(self.selectedIndex)
        }
    }
    
    func updateTabBarItems(colors: [UIColor]) {
        for (index, arsubview) in tabBarItemStackView.arrangedSubviews.enumerated() {
            let tabBarItem = self.tabBarItems[index]
            for subview in arsubview.subviews {
//                print(subview)
                let textColor = index == selectedIndex ? colors[0] : colors[1]
                if subview is UIImageView {
                    let iconImageView = subview as! UIImageView
                    let iconImage = UIImage(named: index == selectedIndex ? tabBarItem.selectedImageName : tabBarItem.imageName)?.withRenderingMode(.alwaysTemplate)
                    iconImageView.tintColor = textColor
                    iconImageView.image = iconImage
                } else if subview is UILabel {
                    let titleLabel = subview as! UILabel
                    titleLabel.textColor = textColor
                }
            }
        }
    }
    
    func getBlurView(style: UIBlurEffect.Style) -> UIVisualEffectView {
        let _blurEffect = UIBlurEffect(style: style)
        let _blurView = UIVisualEffectView(effect: _blurEffect)
        _blurView.autoresizingMask = .flexibleHeight
        return _blurView
    }
    
    func removeBlurView() {
        for subview in contentView.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    func setBlurForTabbar(style: UIBlurEffect.Style) {
        let _blurEffect = UIBlurEffect(style: style)
        self.blurView = UIVisualEffectView(effect: _blurEffect)
        self.contentView.addSubview(self.blurView)
        self.blurView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func hideTabBarItems() {
        self.tabBarItemStackView.frame.origin.y += 100
    }
    
    func showTabBarItems() {
        self.tabBarItemStackView.frame.origin.y = 0
    }
}
