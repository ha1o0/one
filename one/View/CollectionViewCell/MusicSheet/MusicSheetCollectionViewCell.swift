//
//  MusicSheetCollectionViewCell.swift
//  one
//
//  Created by sidney on 5/31/21.
//

import UIKit
import SDWebImage

class MusicSheetCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var posterImageLock = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 10
        posterImageView.contentMode = .scaleAspectFill
    }
    
    func setContent(data: MusicSheet) {
        if data.id == "1" {
            let index = 0
            self.setImage(urlStr: data.posters[0])
            let maxIndex = data.posters.count - 1
            delayLoop(inputIndex: index, maxIndex: maxIndex, data: data)
        } else {
            self.setImage(urlStr: data.posters[0])
        }
        nameLabel.text = data.name
    }
    
    func delayLoop(inputIndex: Int, maxIndex: Int, data: MusicSheet) {
        print("loop")
        var index = inputIndex
        delay(5) {
            index += 1
            if index > maxIndex {
                index = 0
            }
            if !self.posterImageLock {
                self.setImage(urlStr: data.posters[index], withAnimate: true)
            }
            if data.posters.count > 1 {
                self.delayLoop(inputIndex: index, maxIndex: maxIndex, data: data)
            }
        }
    }
    
    func setImage(urlStr: String, withAnimate: Bool = false) {
        if let url = URL(string: urlStr) {
            if !withAnimate {
                self.posterImageView.loadFrom(url: url)
                return
            }
            if posterImageLock {
                return
            }
            self.posterImageLock = true
            posterImageView.alpha = 0
            UIView.animate(withDuration: 0.618) { [self] in
                self.posterImageView.sd_setImage(with: url) { image, Error, cacheType, url in
                    self.posterImageLock = false
                    self.posterImageView.alpha = 1
                }
            } completion: { result in }
        }
    }
    
    deinit {
        print("deinit MusicSheetCollectionViewCell")
    }

}
