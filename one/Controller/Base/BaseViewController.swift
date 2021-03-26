//
//  BaseViewController.swift
//  one
//
//  Created by sidney on 2021/3/20.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if (self.navigationController?.isNavigationBarHidden ?? false) {
//            setCustomNav()
//        }
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setCustomNav() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func setNavigation() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.clear // 如果设置了颜色，顶部的Nav Bar就会显示对应的颜色
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    
    deinit {
        print("---deinit---")
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
