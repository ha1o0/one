//
//  MusicListCellView.swift
//  one
//
//  Created by sidney on 2021/6/2.
//

import Foundation
import UIKit

class MusicListCellView: UIView {
    var bkgView: UIView = {
        let _bkgView = UIView()
        return _bkgView
    }()
    var posterImageView: UIImageView = {
        let _posterImageView = UIImageView()
        return _posterImageView
    }()
    var musicNameLabel: UILabel = {
        let _nameLabel = UILabel()
        _nameLabel.font = UIFont.systemFont(ofSize: 16)
        _nameLabel.textColor = .black
        return _nameLabel
    }()
    var authorLabel: UILabel = {
        let _authorLabel = UILabel()
        _authorLabel.font = UIFont.systemFont(ofSize: 14)
        _authorLabel.textColor = .darkGray
        return _authorLabel
    }()
    var introductionLabel: UILabel = {
        let _introductionLabel = UILabel()
        _introductionLabel.font = UIFont.systemFont(ofSize: 10)
        _introductionLabel.textColor = .darkGray
        return _introductionLabel
    }()
    
    var musicInfo: Music!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakefromnib MusicListCellView")
    }
    
    convenience init(music: Music) {
        self.init()
        self.musicInfo = music
        self.commonInit()
    }
    
    func commonInit() {
        self.addSubview(bkgView)
        bkgView.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        
        bkgView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(60)
            maker.leading.equalToSuperview().offset(5)
        }
        
        bkgView.addSubview(musicNameLabel)
        musicNameLabel.text = musicInfo.name
        musicNameLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(posterImageView.snp.trailing).offset(15)
            maker.top.equalToSuperview().offset(10)
            maker.width.equalTo(100)
        }
        
        bkgView.addSubview(authorLabel)
        authorLabel.text = "-  \(musicInfo.author)"
        authorLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(musicNameLabel.snp.trailing).offset(5)
            maker.centerY.equalTo(musicNameLabel)
            maker.width.equalTo(200)
        }
        
        musicNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        authorLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        bkgView.addSubview(introductionLabel)
        introductionLabel.text = musicInfo.subtitle
        introductionLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-10)
            maker.leading.equalTo(musicNameLabel.snp.leading)
            maker.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func setContent(data: Music) {
        musicNameLabel.text = data.name
        authorLabel.text = "-  \(data.author)"
        introductionLabel.text = data.subtitle
        if let url = URL(string: data.poster) {
            posterImageView.loadFrom(url: url)
            posterImageView.layer.cornerRadius = 10
        }
    }
    
    override func draw(_ rect: CGRect) {
        
    }
}
