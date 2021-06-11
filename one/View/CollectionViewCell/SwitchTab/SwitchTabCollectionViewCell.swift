//
//  SwitchTabCollectionViewCell.swift
//  one
//
//  Created by sidney on 6/10/21.
//

import UIKit

class SwitchTabCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var tabButton: UIButton!
    weak var delegate: SwitchTabDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func switchTab(_ sender: UIButton) {
        self.delegate?.switchTabTo(index: sender.tag, fromClick: true)
    }
    
    func setContent(data: SwitchTab, index: Int, selectedIndex: Int) {
        let isSelected = index == selectedIndex
        self.tabButton.tag = index
        self.tabButton.setTitle(data.titles[index], for: .normal)
        self.tabButton.setTitleColor(isSelected ? data.titleSelectedColor : data.titleColor, for: .normal)
        self.tabButton.titleLabel?.font = UIFont.systemFont(ofSize: isSelected ? data.titleSelectedSize : data.titleSize)
    }
}
