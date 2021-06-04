//
//  MusicListItemCollectionViewCell.swift
//  one
//
//  Created by sidney on 6/3/21.
//

import UIKit

class MusicListItemCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var musicAuthorLabel: UILabel!
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var musicInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 10
        let tag = Capsule(text: "SQ", bkgColor: .clear, borderColor: .red, textColor: .red, UIFont.systemFont(ofSize: 8))
        tagView.addSubview(tag)
        tag.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setContent(data: Music) {
        self.musicNameLabel.text = data.name
        self.musicAuthorLabel.text = data.author
        self.musicInfoLabel.text = data.subtitle
        if let url = URL(string: data.poster) {
            posterImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
