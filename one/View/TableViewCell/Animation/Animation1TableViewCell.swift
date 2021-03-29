//
//  Animation1TableViewCell.swift
//  one
//
//  Created by sidney on 2021/3/29.
//

import UIKit

class Animation1TableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var targetView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func start(_ sender: UIButton) {
        UIView.animate(withDuration: 2) {
            self.targetView.frame.origin.x += 100
        } completion: { (result) in
            
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        self.targetView.frame.origin.x = 16
    }
}
