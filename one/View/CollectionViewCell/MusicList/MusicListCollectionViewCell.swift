//
//  MusicListCollectionViewCell.swift
//  one
//
//  Created by sidney on 2021/6/1.
//

import UIKit

class MusicListCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var cellContentView: UIView!
    
    var rows = 3
    var rowHeight = 60
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for index in 0..<rows {
            let musicListCellView = viewFromNib("MusicListTableViewCell") as! MusicListTableViewCell
            self.cellContentView.addSubview(musicListCellView)
            musicListCellView.snp.makeConstraints { (maker) in
                maker.leading.trailing.equalToSuperview()
                maker.top.equalToSuperview().offset(index * rowHeight)
                maker.height.equalTo(rowHeight)
            }
        }
    }
    
    func setContent(data: [Music]) {
        for (index, subview) in self.cellContentView.subviews.enumerated() {
            let subcontentView = subview as! MusicListTableViewCell
            subcontentView.setContent(data: data[index])
        }
    }

}
