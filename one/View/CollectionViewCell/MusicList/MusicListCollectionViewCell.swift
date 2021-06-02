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
    var rowHeight = 70
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib MusicListCollectionViewCell")
        for index in 0..<rows {
            let music = Music(id: "", poster: "", name: "123", subtitle: "456", playCount: 0, author: "789")
            let musicListCellView = MusicListCellView(music: music)
            self.cellContentView.addSubview(musicListCellView)
            musicListCellView.snp.makeConstraints { (maker) in
                maker.leading.trailing.equalToSuperview()
                maker.top.equalToSuperview().offset(index * rowHeight)
                maker.height.equalTo(rowHeight)
            }
        }
    }
    
    func setContent(data: [Music]) {
        print("setcontent")
        for (index, subview) in self.cellContentView.subviews.enumerated() {
            let subcontentView = subview as! MusicListCellView
            subcontentView.setContent(data: data[index])
        }
    }

}
