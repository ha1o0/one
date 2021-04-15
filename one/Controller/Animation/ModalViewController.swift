//
//  ModalViewController.swift
//  one
//
//  Created by sidney on 2021/4/15.
//

import UIKit

class ModalTestVc: BaseViewController {
    override func back() {
        self.dismiss(animated: true) {
            print("has dismissed")
        }
    }
}

class ModalViewController: BaseViewController {

    var newVc = ModalTestVc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newVc.title = "new"
        newVc.setCustomNav()
        // Do any additional setup after loading the view.
    }


    @IBAction func coverVertical(_ sender: UIButton) {
        newVc.modalTransitionStyle = .coverVertical
        self.present(newVc, animated: true, completion: nil)
    }
    
    @IBAction func flipHorizontal(_ sender: UIButton) {
        newVc.modalTransitionStyle = .flipHorizontal
        self.present(newVc, animated: true, completion: nil)
    }

    @IBAction func crossDissolve(_ sender: UIButton) {
        newVc.modalTransitionStyle = .crossDissolve
        self.present(newVc, animated: true, completion: nil)
    }
    
    @IBAction func partialCurl(_ sender: UIButton) {
        // 有问题
//        newVc.modalTransitionStyle = .partialCurl
//        newVc.modalPresentationStyle = .fullScreen
//        self.present(newVc, animated: true, completion: nil)
    }
    
}
