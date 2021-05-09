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
        let number = arc4random() % 100
        if number > 50 {
            return
        }
        let capsule = Capsule(text: "测试", bkgColor: .gray, borderColor: .clear, textColor: .white)
        self.contentView.addSubview(capsule)
        capsule.snp.makeConstraints { (maker ) in
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(nameLabel.snp.trailing).offset(5)
            maker.width.equalTo(50)
            maker.height.equalTo(20)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(data: IdName) {
        self.nameLabel.text = data.name
    }
    
}
