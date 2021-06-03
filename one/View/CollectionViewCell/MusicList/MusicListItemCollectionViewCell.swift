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
    @IBOutlet weak var musicInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 10
        // Initialization code
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
