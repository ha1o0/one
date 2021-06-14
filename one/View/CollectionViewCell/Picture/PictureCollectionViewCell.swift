//
//  PictureCollectionViewCell.swift
//  one
//
//  Created by sidney on 2021/4/11.
//

import UIKit

class PictureCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    func setCell(data: Video) {
        if let url = URL(string: data.poster) {
            posterImageView.sd_setImage(with: url, completed: nil)
        }
        if data.avatar.count > 0, let avatar = URL(string: data.avatar) {
            avatarImageView.sd_setImage(with: avatar, completed: nil)
        }
        titleLabel.text = data.title
        subtitleLabel.text = "\(data.subtitle)-\(arc4random() % 1000)"
    }
    
    @IBAction func more(_ sender: UIButton) {
        
    }
    
}
