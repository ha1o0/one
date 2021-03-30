//
//  Animation3TableViewCell.swift
//  one
//
//  Created by sidney on 2021/3/30.
//

import UIKit

class Animation3TableViewCell: AnimationTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.text = "翻转+缩小"
        tips = "targetView.transform3D -> CATransform3DMakeScale+CATransform3DMakeRotation"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func start() {
        UIView.animate(withDuration: 3) {
//            self.targetView.transform3D = CATransform3DMakeTranslation(50, 50, 50)
            self.targetView.transform3D = CATransform3DMakeScale(0.5, 0.2, 0.5)
            self.targetView.transform3D = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0.3)
        } completion: { (result) in
            
        }

    }
    
    override func reset() {
        targetView.transform3D = CATransform3DMakeScale(1, 1, 1)
    }
}
