//
//  BaseTestViewController.swift
//  one
//
//  Created by sidney on 5/7/21.
//

import UIKit

class BaseTestViewController: BaseViewController {
    @IBOutlet weak var view1: UIView!
    
    var view3 = UIView()
    var view4 = UIView()
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
        
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 30))
        btn.setTitle("按钮1", for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        view.addSubview(btn)
        let btn2 = UIButton(frame: CGRect(x: 200, y: 100, width: 100, height: 30))
        btn2.setTitle("按钮2", for: .normal)
        btn2.tintColor = .white
        btn2.addTarget(self, action: #selector(clickButton2), for: .touchUpInside)
        view.addSubview(btn2)

        
        view3.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 100 - 200, width: SCREEN_WIDTH, height: 40)
        self.view.addSubview(view3)
        view3.backgroundColor = .red
        
        
        self.view.addSubview(view4)
        view4.backgroundColor = .yellow
        view4.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-140)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(60)
        }
    }
    
    @objc func clickButton() {
        print(self.view3.center)
        print(self.view3.frame)
        UIView.animate(withDuration: 0.6) {
//            self.view3.frame.origin.y += 20
            self.view3.frame.size.height += 30
//            self.view4.frame.origin.y += 20
//            self.view4.transform = CGAffineTransform(translationX: 0, y: 20)
        } completion: { (result) in
            print(self.view3.center)
            print(self.view3.frame)
        }
    }
    
    @objc func clickButton2() {
        UIView.animate(withDuration: 0.6) {
//            self.view3.frame.origin.y -= 20
            self.view3.frame.size.height -= 30
//            self.view4.frame.origin.y += 20
//            self.view4.transform = CGAffineTransform(translationX: 0, y: -20)
        }
    }
}
