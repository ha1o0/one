//
//  BaseTestViewController.swift
//  one
//
//  Created by sidney on 5/7/21.
//

import UIKit

class BaseTestViewController: BaseViewController {
    @IBOutlet weak var view1: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view1 = UIView()
        view1.backgroundColor = .orange
        self.view.addSubview(view1)
        view1.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(50)
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(-20)
            maker.height.equalTo(200)
        }
        let oldFrame1 = view1.frame
        view1.layer.anchorPoint = CGPoint(x: 0, y: self.view.frame.width / 2)
        view1.frame = oldFrame1
//        delay(3) {
//            print("delayexec")
//            view1.backgroundColor = .red
//            view1.snp.updateConstraints { (maker) in
//                maker.top.equalToSuperview().offset(50)
//                maker.leading.equalToSuperview().offset(20)
//                maker.trailing.equalToSuperview().offset(-20)
//                maker.height.equalTo(300)
//            }
//        }
        
        
        let width = SCREEN_WIDTH - 40
        let view2 = UIView(frame: CGRect(x: 20, y: 300, width: width, height: 200))
        view2.backgroundColor = .blue
        self.view.addSubview(view2)
        let oldFrame2 = view2.frame
        view2.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        view2.frame = oldFrame2
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
