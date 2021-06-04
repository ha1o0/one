//
//  MusicKTVItemCollectionViewCell.swift
//  one
//
//  Created by sidney on 6/4/21.
//

import UIKit

class MusicKTVItemCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var playingView: UIView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNumberLabel: UILabel!
    @IBOutlet weak var imageOuterView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageOuterView.layer.cornerRadius = imageOuterView.bounds.width / 2
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        let gif = UIImage.gifImageWithName("playing")
        let gifImageView = UIImageView(image: gif)
        playingView.addSubview(gifImageView)
        gifImageView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalTo(25)
            maker.height.equalTo(15)
        }
    }

    func setContent(data: MusicKTV) {
        musicNameLabel.text = data.currentMusicName
        titleLabel.text = data.roomTitle
        userNumberLabel.text = "\(data.roomUserNumber)人"
        if let url = URL(string: data.currentImage) {
            imageView.sd_setImage(with: url, completed: nil)
        }
        let color1 = UIColor.colorWithHexString(data.roomColors[0]).cgColor
        let color2 = UIColor.colorWithHexString(data.roomColors[1]).cgColor
        bkgView.setGradientBackgroundColor(colors: [color1, color2], locations: [0, 1], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1,y: 1), 10)
    }
}
