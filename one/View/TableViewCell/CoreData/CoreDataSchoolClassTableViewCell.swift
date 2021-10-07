//
//  CoreDataSchoolClassTableViewCell.swift
//  one
//
//  Created by sidney on 2021/10/7.
//

import UIKit

class CoreDataSchoolClassTableViewCell: BaseTableViewCell {

    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var studentCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(schoolClass: SchoolClass) {
        print(schoolClass)
        print("\(schoolClass.name):\(schoolClass.studentCount)")
        self.classNameLabel.text = schoolClass.name
        self.studentCountLabel.text = "\(schoolClass.studentCount)"
    }
    
}
