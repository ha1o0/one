//
//  Tab2CollectionViewCell.swift
//  one
//
//  Created by sidney on 6/11/21.
//

import UIKit
import SDWebImage

class Tab2CollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: CollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bkgView.layer.cornerRadius = 10
        self.imageView.layer.cornerRadius = 10
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setContent(data: SimpleVideo, indexPath: IndexPath) {
        print("set content")
        self.titleLabel.text = data.title
        self.deleteButton.tag = indexPath.row
        if let url = URL(string: data.poster) {
            self.imageView.sd_setImage(with: url) { image, _, _, _ in
//                print("get image")
//                guard let image = image else { return }
//                let newHeight = (image.size.height * (SCREEN_WIDTH - 30) / 2) / image.size.width
//                if newHeight != self.imageView.bounds.height {
//                    self.imageHeightConstraint.constant = (image.size.height * (SCREEN_WIDTH - 30) / 2) / image.size.width
//                }

//                self.delegate?.reloadIndexPath(indexPath)
            }
            if let image = SDImageCache.shared.imageFromCache(forKey: data.poster) {
                self.imageHeightConstraint.constant = (image.size.height * (SCREEN_WIDTH - 30) / 2) / image.size.width
            }
        }
    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
        let indexRow = sender.tag
        self.delegate?.deleteIndexPath(IndexPath(row: indexRow, section: 0))
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
            let targetSize = CGSize(width: (SCREEN_WIDTH - 30) / 2, height: 0)
            layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            return layoutAttributes
        }

}
