//
//  OpenHomeViewController.swift
//  one
//
//  Created by sidney on 6/10/21.
//

import UIKit

class OpenHomeViewController: BaseTabBarViewController {

    let titles = ["关注", "广场", "精选"]
    var switchTabData = SwitchTab()
    var switchTabView: SwitchTabView = SwitchTabView()
    var liveListView: LiveListView = LiveListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomNav(color: .clear)
        self.leftView.removeFromSuperview()
        switchTabData = SwitchTab(titles: titles, hasBottomLine: false, titleSelectedColor: .label, titleColor: .systemGray, titleSize: 18, titleSelectedSize: 18, linespacing: 10.0)
        switchTabView = SwitchTabView(switchTab: switchTabData)
        self.view.addSubview(switchTabView)
        switchTabView.snp.makeConstraints { (maker) in
            maker.height.equalTo(STATUS_NAV_HEIGHT - STATUS_BAR_HEIGHT)
            maker.width.equalTo(getCollectionWidth(titles: titles, linespacing: switchTabData.linespacing))
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(STATUS_BAR_HEIGHT)
        }
        
        let viewHeight = SCREEN_HEIGHT - STATUS_NAV_HEIGHT
        let a = Tab1ViewController()
        let b = Tab2ViewController()
        let c = Tab1ViewController()
        let controllers = [a, b, c]
        var pageViewList = [UIView]()
        for controller in controllers {
            // 重设frame
            controller.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: viewHeight)
            pageViewList.append(controller.view)
            self.addChild(controller)
        }
        
        liveListView = LiveListView(frame: CGRect(x: 0, y: STATUS_NAV_HEIGHT, width: SCREEN_WIDTH, height: viewHeight), pageViewList: pageViewList, switchTabView: self.switchTabView, callback: { (offset) in
//            print(offset)
        })
        
        
        self.view.addSubview(liveListView)
    }
    
    func getCollectionWidth(titles: [String], fontSize: CGFloat = 18, linespacing: CGFloat = 0) -> CGFloat {
        var totalWidth: CGFloat = 0
        for title in titles {
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
            let width = title.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: STATUS_NAV_HEIGHT - STATUS_BAR_HEIGHT), options: NSStringDrawingOptions.usesFontLeading, attributes: attributes, context: nil).size.width + 15
            totalWidth += width
        }
        totalWidth += linespacing * CGFloat(titles.count)
        print(totalWidth)
        return min(totalWidth, SCREEN_WIDTH)
    }
}
