//
//  MainViewController.swift
//  one
//
//  Created by sidney on 5/10/21.
//

import UIKit

class MainViewController: UIViewController {

    var tabbarVc: TabBarViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("main didload")
        tabbarVc = TabBarViewController()
        appDelegate.window?.rootViewController = tabbarVc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("main willappear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("main didappear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        print("main willdisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        print("main diddisappear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        print("main willlayoutsubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("main didlayoutsubviews")
    }
}
