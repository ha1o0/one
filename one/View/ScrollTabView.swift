//
//  ScrollTabView.swift
//  diyplayer
//
//  Created by sidney on 2019/12/8.
//  Copyright © 2019 sidney. All rights reserved.
//

import UIKit

class ScrollTabView: UIView {

    var tabTitles:[String] = []
    var hasBottomLine:Bool = true
    var titleSelectedColor:UIColor = UIColor.main
    var titleColor:UIColor = UIColor.gray
    var titleSize:CGFloat = 15.0
    var titleSelectedSize:CGFloat = 17.0
    var currentIndex = 0
    var tabScrollView = UIScrollView()
    var underLineView = UIView()
    var tabControllers:[UIViewController] = []
    var tabContentViews:[UIView] = []
    var underLineViewWidth:CGFloat = 0
    var underLineViewLeading:CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("initframe")
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        underLineViewWidth = underLineView.frame.width
        underLineViewLeading = underLineView.frame.origin.x
        print("aaa: ", underLineViewWidth)
    }
    
    
    func setUp() {
        tabScrollView.backgroundColor = UIColor.systemBackground
        self.addSubview(tabScrollView)
        tabScrollView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        var contentWidth:CGFloat = 0
        for (_, title) in self.tabTitles.enumerated() {
            let titleButton = UIButton()
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
            let width = (title.boundingRect(with: CGSize(width: UIScreen.main.bounds.width, height: 30), options: NSStringDrawingOptions.usesFontLeading, attributes: attributes, context: nil).size.width) + 15
            titleButton.setTitle(title, for: .normal)
//            titleButton.titleLabel?.sizeToFit()
//            titleButton.titleLabel?.adjustsFontSizeToFitWidth = true
            titleButton.setTitleColor(self.titleSelectedColor, for: .selected)
            tabScrollView.addSubview(titleButton)
            titleButton.snp.makeConstraints { (maker) in
                maker.centerY.equalToSuperview()
                maker.leading.equalToSuperview().offset(10 + contentWidth)
                maker.height.equalTo(30)
                maker.width.equalTo(width)
            }

            contentWidth += (20 + width)
        }
        self.setButtonSelected(selectedIndex: self.currentIndex, direction: 0)
        tabScrollView.contentSize = CGSize(width: contentWidth, height: tabScrollView.frame.size.height)
        self.setTabUnderline()
    }
    
    func setButtonSelected(selectedIndex: Int, direction: CGFloat) {
        for (index, subview) in tabScrollView.subviews.enumerated() {
            if (index >= tabTitles.count) {
                break
            }
            let button = subview as! UIButton
            let titleColor = index == selectedIndex ? self.titleSelectedColor : self.titleColor
            let titleSize = index == selectedIndex ? self.titleSelectedSize : self.titleSize
            button.setTitleColor(titleColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(titleSize))
        }
        currentIndex = selectedIndex
        if (currentIndex > 2) {
            let currentContentOffset = tabScrollView.contentOffset
            let contentSize = tabScrollView.contentSize
            let maxOffsetX = contentSize.width - tabScrollView.frame.width
            if (direction > 0) {
                let shouldOffset = currentContentOffset.x + 50
                tabScrollView.setContentOffset(CGPoint(x: shouldOffset < maxOffsetX ? shouldOffset : maxOffsetX, y: currentContentOffset.y), animated: true)
            } else if (direction < 0) {
                let shouldOffset = currentContentOffset.x - 50
                tabScrollView.setContentOffset(CGPoint(x: shouldOffset > 0 ? shouldOffset : 0, y: currentContentOffset.y), animated: true)
            }
        }
    }
    
    func setTabUnderline() {
        if !hasBottomLine {
            return
        }
        underLineView.backgroundColor = self.titleSelectedColor
        underLineView.layer.cornerRadius = 1.5
        let buttons:[UIButton] = tabScrollView.subviews as! [UIButton]
        let currentButton = buttons[currentIndex]
        tabScrollView.addSubview(underLineView)
        underLineView.snp.makeConstraints { (maker) in
            maker.width.equalTo(30)
            maker.height.equalTo(3)
            maker.centerX.equalTo(currentButton)
            maker.top.equalTo(currentButton.snp.bottom)
        }
    }
    
    func slideUnderline(offset: CGFloat) {
        if !hasBottomLine {
            return
        }
        let relativeOffset = offset - CGFloat(currentIndex)
        print(relativeOffset)
        let buttons:[UIButton] = tabScrollView.subviews as! [UIButton]
        let currentButton = buttons[currentIndex]
        var subWidth = CGFloat.zero
        var subLeading = CGFloat.zero
        if (currentIndex == (tabTitles.count - 1) && relativeOffset > 0) || (currentIndex == 0 && relativeOffset < 0) {
            return
        }
        if currentIndex < (tabTitles.count - 1) && relativeOffset > 0 {
            subWidth = CGFloat(buttons[currentIndex + 1].frame.width) - CGFloat(currentButton.frame.width)
            subLeading = CGFloat(buttons[currentIndex + 1].frame.origin.x) - CGFloat(currentButton.frame.origin.x)
        }
        if currentIndex > 0 && relativeOffset < 0 {
            subWidth = CGFloat(currentButton.frame.width) - CGFloat(buttons[currentIndex - 1].frame.width)
            subLeading = CGFloat(currentButton.frame.origin.x) - CGFloat(buttons[currentIndex - 1].frame.origin.x)
        }
        
        underLineView.snp.remakeConstraints { (maker) in
            
            let changeWidth = underLineViewWidth + relativeOffset * subWidth
            let changeLeading = underLineViewLeading + relativeOffset * subLeading
            if (CGFloat(Int(offset)) - offset == 0.0) {
                underLineViewWidth = changeWidth
                underLineViewLeading = changeLeading
                setButtonSelected(selectedIndex: Int(offset), direction: relativeOffset)
            }
            if (changeWidth > 0) {
                maker.width.equalTo(changeWidth)
            }
            maker.height.equalTo(3)
            if (changeLeading > 0) {
                maker.leading.equalToSuperview().offset(changeLeading)
            }
            maker.top.equalTo(currentButton.snp.bottom)
            
        }
        
    }
    
    func setTabViewControllers() {
        
    }

}
