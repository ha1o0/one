//
//  FunctionCollectionViewCell.swift
//  one
//
//  Created by sidney on 2021/5/27.
//

import UIKit

class FunctionCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var imageBkgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let circleLayer = CALayer()
        circleLayer.frame = imageBkgView.bounds
        circleLayer.cornerRadius = imageBkgView.bounds.size.width / 2
        circleLayer.backgroundColor = UIColor.main.withAlphaComponent(0.1).cgColor
        imageBkgView.layer.insertSublayer(circleLayer, at: 0)
    }

    func setContent(data: MusicFunction) {
        imageView.image = UIImage(named: data.icon)
        nameLabel.text = data.name
    }
}
