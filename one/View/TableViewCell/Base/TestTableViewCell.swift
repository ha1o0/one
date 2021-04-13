//
//  TestTableViewCell.swift
//  one
//
//  Created by sidney on 2021/4/13.
//

import UIKit

class TestTableViewCell: BaseTableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent() {
        let number = arc4random() % 100
        var numberString = "\(number)"
        if number > 50 {
            numberString = "\(number)这是一段很长的文字，会换行，这是一段很长的文字，会换行，这是一段很长的文字，会换行"
        } else {
            numberString = "\(number)"
        }
        numberLabel.text = "\(numberString)"
    }
    
}
