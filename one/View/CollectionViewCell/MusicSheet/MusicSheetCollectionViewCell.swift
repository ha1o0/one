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
        posterImageView.contentMode = .scaleAspectFill
    }
    
    func setContent(data: MusicSheet) {
        if data.id == "1" {
            var index = 0
            self.setImage(urlStr: data.posters[0])
            let maxIndex = data.posters.count - 1
            Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { timer in
                index += 1
                if index > maxIndex {
                    index = 0
                }
                self.setImage(urlStr: data.posters[index], withAnimate: true)
            }
        } else {
            self.setImage(urlStr: data.posters[0])
        }
        nameLabel.text = data.name
    }
    
    func setImage(urlStr: String, withAnimate: Bool = false) {
        if let url = URL(string: urlStr) {
            self.posterImageView.loadFrom(url: url)
            if !withAnimate {
                return
            }
            posterImageView.alpha = 0
            UIView.animate(withDuration: 0.618) { [self] in
                self.posterImageView.alpha = 1
            } completion: { result in }
        }
    }
    
    deinit {
        print("deinit MusicSheetCollectionViewCell")
    }

}
