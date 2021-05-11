//
//  DrawerViewController.swift
//  one
//
//  Created by sidney on 5/10/21.
//

import UIKit

class DrawerViewController: BaseViewController {

    lazy var contentView: UIView = {
        let _contentView = UIView()
        return _contentView
    }()
    
    var tabbarVc: TabBarViewController? {
        didSet {
            if tabbarVc != nil {
                contentView.addSubview(tabbarVc!.view)
                tabbarVc!.view.frame = self.contentView.frame
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
