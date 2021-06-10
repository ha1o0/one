//
//  OpenHomeViewController.swift
//  one
//
//  Created by sidney on 6/10/21.
//

import UIKit

class OpenHomeViewController: BaseTabBarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomNav(color: .clear)
        let titles = ["关注", "广场", "精选"]
        let switchTabData = SwitchTab(titles: titles, hasBottomLine: false, titleSelectedColor: .label, titleColor: .systemGray, titleSize: 18, titleSelectedSize: 18, linespacing: 10)
        let switchTabView = SwitchTabView(switchTab: switchTabData)
        self.view.addSubview(switchTabView)
        
        switchTabView.snp.makeConstraints { (maker) in
            maker.height.equalTo(STATUS_NAV_HEIGHT - STATUS_BAR_HEIGHT)
            maker.width.equalTo(getCollectionWidth(titles: titles, linespacing: switchTabData.linespacing))
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(STATUS_BAR_HEIGHT)
        }
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
