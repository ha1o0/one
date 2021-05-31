//
//  MusicSheetCollectionViewCell.swift
//  one
//
//  Created by sidney on 5/31/21.
//

import UIKit

class MusicSheetCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 10
    }
    
    func setContent(data: MusicSheet) {
        if let url = URL(string: data.posters[0]) {
            posterImageView.loadFrom(url: url)
            posterImageView.contentMode = .scaleAspectFill
        }
        nameLabel.text = data.name
    }

}
