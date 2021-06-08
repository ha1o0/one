//
//  BaseTabBarViewController.swift
//  one
//
//  Created by sidney on 5/10/21.
//

import UIKit

class BaseTabBarViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("basetabbar didload")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.rootVc?.drawerVc.tabbarVc?.showTabbar()
//        print("basetabbar willappear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        print("basetabbar willdisappear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("basetabbar didappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        print("basetabbar diddisappear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        print("basetabbar willlayoutsubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("basetabbar didlayoutsubviews")
    }
}
