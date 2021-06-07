//
//  LeftDrawerTableViewCell.swift
//  one
//
//  Created by sidney on 5/18/21.
//

import UIKit

class LeftDrawerTableViewCell: BaseTableViewCell {

    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var settingIconView: UIImageView!
    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var extraView: UIView!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var rightArrow: UIButton!
    @IBOutlet weak var splitLineView: UIView!
    var isFirst = false
    var isLast = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switchView.onTintColor = .main
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContent(item: LeftDrawerItem, isFirst: Bool, isLast: Bool) {
        settingIconView.image = UIImage(named: item.iconName)
        settingNameLabel.text = item.name
        splitLineView.isHidden = true
        if item.hasSwitch {
            rightArrow.isHidden = true
            extraView.isHidden = true
            switchView.isHidden = false
        } else {
            rightArrow.isHidden = false
            extraView.isHidden = false
            switchView.isHidden = true
        }
        bkgView.layer.masksToBounds = true
        if isFirst {
            bkgView.layer.cornerRadius = 10
            bkgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLast {
            bkgView.layer.cornerRadius = 10
            bkgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            bkgView.layer.cornerRadius = 0
            bkgView.layer.maskedCorners = []
        }
    }
}
