//
//  BaseTestViewController.swift
//  one
//
//  Created by sidney on 5/7/21.
//

import UIKit

class BaseTestViewController: BaseTabBarViewController {
    @IBOutlet weak var view1: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomNav()
        let view1 = UIView()
        view1.backgroundColor = .orange
        view1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view1)
        view1.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(100)
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(-20)
            maker.height.equalTo(200)
        }
        
        // important!!!
        view1.layoutIfNeeded()

        let oldFrame1 = view1.frame
        view1.layer.anchorPoint = CGPoint(x: 0, y: 0.5)

        view1.snp.updateConstraints { (maker) in
            let subOffset = oldFrame1.width * 0.5
            maker.leading.equalToSuperview().offset(20 - subOffset)
            maker.trailing.equalToSuperview().offset(-20 - subOffset)
        }

        let width = SCREEN_WIDTH - 40
        let view2 = UIView(frame: CGRect(x: 20, y: 300, width: width, height: 200))
        view2.backgroundColor = .blue
        self.view.addSubview(view2)
        let oldFrame2 = view2.frame
        view2.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        view2.frame = oldFrame2
    }
}
