//
//  Tab2CollectionViewCell.swift
//  one
//
//  Created by sidney on 6/11/21.
//

import UIKit

class Tab2CollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bkgView.layer.cornerRadius = 10
        self.imageView.layer.cornerRadius = 10
    }

    func setContent(data: SimpleVideo) {
        self.titleLabel.text = data.title
        if let url = URL(string: data.poster) {
            self.imageView.sd_setImage(with: url) { image, _, _, _ in

            }
        }
    }
}
