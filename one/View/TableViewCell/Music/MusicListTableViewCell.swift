//
//  MusicListTableViewCell.swift
//  one
//
//  Created by sidney on 2021/6/1.
//

import UIKit

class MusicListTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.posterImageView.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContent(data: Music) {
        if let url = URL(string: data.poster) {
            self.posterImageView.sd_setImage(with: url, completed: nil)
        }
        self.musicNameLabel.text = data.name
        self.authorLabel.text = data.author
        self.introductionLabel.text = data.subtitle
    }
    
}
