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
        button.addTarget(self, action: #selector(start), for: .touchUpInside)
        return button
    }()
    lazy var resetButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("复原", for: .normal)
        button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return button
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        titleLabel.text = "动画"
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.leading.top.equalToSuperview().offset(16)
        }
        targetView.backgroundColor = .orange
        addSubview(targetView)
        targetView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            maker.leading.equalTo(self.titleLabel.snp.leading)
            maker.width.height.equalTo(70)
            maker.bottom.equalToSuperview().offset(-16)
        }

        addSubview(startButton)
        startButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        addSubview(resetButton)
        resetButton.snp.makeConstraints { (maker) in
            maker.leading.equalTo(startButton.snp.trailing).offset(10)
            maker.bottom.equalTo(titleLabel.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func start(_ sender: UIButton) {
        print("start")
    }
    
    @objc func reset(_ sender: UIButton) {
        
    }

}
