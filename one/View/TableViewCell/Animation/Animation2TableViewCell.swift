//
//  Animation2TableViewCell.swift
//  one
//
//  Created by sidney on 2021/3/29.
//

import UIKit

class Animation2TableViewCell: AnimationTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.text = "旋转"
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func start(_ sender: UIButton) {
        UIView.animate(withDuration: 3) {
            self.targetView.rotate(angle: 360)
        } completion: { (result) in
            
        }

    }
    
    override func reset(_ sender: UIButton) {
        
    }
}
