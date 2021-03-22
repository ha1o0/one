//
//  FunctionListTableViewCell.swift
//  one
//
//  Created by sidney on 2021/3/22.
//

import UIKit

class FunctionListTableViewCell: BaseTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(data: IdName) {
        self.nameLabel.text = data.name
    }
    
}
