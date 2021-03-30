//
//  AnimationTableViewCell.swift
//  one
//
//  Created by sidney on 2021/3/29.
//

import UIKit

class AnimationTableViewCell: BaseTableViewCell {

    lazy var titleLabel: UILabel = UILabel()
    lazy var targetView: UIView = UIView()
    lazy var startButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("开始", for: .normal)
        return button
    }()
    lazy var resetButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("复原", for: .normal)
        return button
    }()
    lazy var tipButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("?", for: .normal)
        return button
    }()
    var tips = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        titleLabel.text = "动画"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview().offset(16)
        }
        targetView.backgroundColor = .orange
        contentView.addSubview(targetView)
        targetView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            maker.leading.equalTo(self.titleLabel.snp.leading)
            maker.width.height.equalTo(70)
            maker.bottom.equalToSuperview().offset(-16)
        }

        contentView.addSubview(startButton)
        startButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        contentView.addSubview(resetButton)
        resetButton.snp.makeConstraints { (maker) in
            maker.leading.equalTo(startButton.snp.trailing).offset(10)
            maker.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        contentView.addSubview(tipButton)
        tipButton.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(contentView.snp.trailing).offset(-16)
            maker.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        tipButton.addTarget(self, action: #selector(tip), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func start() {

    }
    
    @objc func reset() {
        
    }
    
    @objc func tip() {
        self.contentView.makeToast(tips)
    }

}
