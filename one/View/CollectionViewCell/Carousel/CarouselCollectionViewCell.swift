//
//  CarouselCollectionViewCell.swift
//  one
//
//  Created by sidney on 5/25/21.
//

import UIKit

class CarouselCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setContent(data: MusicPoster) {
        if let url = URL(string: data.url) {
            imageView.loadFrom(url: url)
            imageView.contentMode = .scaleToFill
        }
    }

}
