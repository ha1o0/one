//
//  MemberCardView.swift
//  one
//
//  Created by sidney on 5/17/21.
//

import UIKit

class MemberCardView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    lazy var capsule: Capsule = {
        let _capsule = Capsule(text: "会员中心", bkgColor: .white, borderColor: .clear, textColor: .cardColor1)
        return _capsule
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        // 注意要在布局结束后设置渐变和圆角layer
        if buttonView.subviews.count == 0 {buttonView.addSubview(capsule)
            capsule.snp.makeConstraints { (maker) in
                maker.leading.bottom.top.trailing.equalToSuperview()
            }
            contentView.setGradientBackgroundColor(colors: [UIColor.cardColor2.cgColor, UIColor.cardColor1.cgColor], locations: [0], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
            contentView.layer.cornerRadius = 10
            contentView.layer.masksToBounds = true
        }
    }
    
}
