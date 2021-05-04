//
//  ModalViewController.swift
//  one
//
//  Created by sidney on 2021/4/15.
//

import UIKit

class ModalViewController: BaseViewController {

    var newVc = BaseViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "转场方式"
        setCustomNav()
        newVc.title = "new"
        newVc.view.backgroundColor = .systemBackground
        newVc.enterType = .present
        newVc.setCustomNav()
        // Do any additional setup after loading the view.
    }


    @IBAction func coverVertical(_ sender: UIButton) {
        newVc.enterType = .present
        newVc.modalTransitionStyle = .coverVertical
        self.present(newVc, animated: true, completion: nil)
    }
    
    @IBAction func flipHorizontal(_ sender: UIButton) {
        newVc.enterType = .present
        newVc.modalTransitionStyle = .flipHorizontal
        self.present(newVc, animated: true, completion: nil)
    }

    @IBAction func crossDissolve(_ sender: UIButton) {
        newVc.enterType = .present
        newVc.modalTransitionStyle = .crossDissolve
        self.present(newVc, animated: true, completion: nil)
    }
    
    @IBAction func partialCurl(_ sender: UIButton) {
        newVc.enterType = .push
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
//        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(newVc, animated: false)
    }
    
    @IBAction func fromBottom(_ sender: UIButton) {
        newVc.enterType = .push
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(newVc, animated: false)
    }
    @IBAction func fold(_ sender: UIButton) {
        view.setAnchor(point: CGPoint(x: 0, y: 0.5))
        UIView.animate(withDuration: 3) {
//            self.targetView.transform3D = CATransform3DMakeTranslation(50, 50, 50)
            self.view.transform3D = CATransform3DMakeRotation(CGFloat.pi / 3 , 0, 500, 0)
        } completion: { (result) in
            
        }
    }
}
