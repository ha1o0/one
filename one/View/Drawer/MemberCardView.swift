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
        let _capsule = Capsule(text: "会员中心", bkgColor: .clear, borderColor: .white, textColor: .white)
        return _capsule
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.setGradientBackgroundColor(colors: [UIColor.cardColor1.cgColor, UIColor.cardColor2.cgColor], locations: [0], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        buttonView.addSubview(capsule)
        capsule.snp.makeConstraints { (maker) in
            maker.leading.bottom.top.trailing.equalToSuperview()
        }
        contentView.setRoundCorners(corners: UIRectCorner(arrayLiteral: .topLeft, .topRight, .bottomLeft, .bottomRight), with: 10)
    }
    
}
