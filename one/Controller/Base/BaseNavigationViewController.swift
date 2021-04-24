//
//  BaseNavigationViewController.swift
//  one
//
//  Created by sidney on 2021/3/21.
//

import UIKit

class BaseNavigationViewController: UINavigationController, UINavigationControllerDelegate {

    var popDelegate:UIGestureRecognizerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.green]
        self.popDelegate = self.interactivePopGestureRecognizer?.delegate
        self.delegate = self
//         Do any additional setup after loading the view.
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if (viewController == self) {
//            navigationController.setNavigationBarHidden(true, animated: true)
//        } else {
//
//        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController == self.viewControllers[0] {
            self.interactivePopGestureRecognizer?.delegate = self.popDelegate
        } else {
            self.interactivePopGestureRecognizer?.delegate = nil
        }
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
