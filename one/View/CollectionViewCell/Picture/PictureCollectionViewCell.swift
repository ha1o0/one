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
        contentView.backgroundColor = .white
        avatarImageView.image = avatarImageView.image?.toCircle()
    }
    
    func setCell(data: Video) {
        if let url = URL(string: data.poster) {
            posterImageView.loadFrom(url: url)
        }
        
        titleLabel.text = data.title
        subtitleLabel.text = "\(data.subtitle)-\(arc4random() % 1000)"
    }
    
    @IBAction func more(_ sender: UIButton) {
        
    }
    
}
