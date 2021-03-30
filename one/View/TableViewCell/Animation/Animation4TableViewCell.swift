//
//  Animation4TableViewCell.swift
//  one
//
//  Created by sidney on 2021/3/30.
//

import UIKit

class Animation4TableViewCell: AnimationTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.text = "弹性抖动"
        tips = "UIView.animate(usingSpringWithDamping, initialSpringVelocity)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func start() {
        UIView.animate(withDuration: 1 , delay: 0 , usingSpringWithDamping: 0.5 , initialSpringVelocity: 6 , options: [] , animations: {
          self.targetView.center.x += 200
        }, completion: nil)

    }
    
    override func reset() {
        self.targetView.frame.origin.x = 16
    }
}
