//
//  ModalViewController.swift
//  one
//
//  Created by sidney on 2021/4/15.
//

import UIKit

class ModalViewController: BaseViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var contentViewTop: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeading: NSLayoutConstraint!
    var newVc = BaseViewController()
    let leftBarViewWidth: CGFloat = 44
    var hasFold = false
    lazy var leftBarView: UIView = {
        let _leftBarView = UIView()
        _leftBarView.backgroundColor = .main
        return _leftBarView
    }()
    lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = .black
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
    lazy var leftViewBackBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = .white
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "转场方式"
        setupLeftBar()
        setCustomNav(color: .white)
        newVc.title = "new"
        newVc.view.backgroundColor = .systemBackground
        newVc.enterType = .present
        newVc.setCustomNav()
        // Do any additional setup after loading the view.
    }
    
    func setupLeftBar() {
        self.view.addSubview(leftBarView)
        leftBarView.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.equalToSuperview()
            maker.width.equalTo(leftBarViewWidth)
        }
        leftBarView.addSubview(leftViewBackBtn)
        leftViewBackBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(STATUS_BAR_HEIGHT + 10)
        }
        leftBarView.alpha = 0
    }
    
    override func setStatusBar(color: UIColor = UIColor.main) {
        contentView.addSubview(statusBarView)
        statusBarView.backgroundColor = color
        statusBarView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.height.equalTo(STATUS_BAR_HEIGHT)
        }
    }
    
    override func setCustomNav(color: UIColor = UIColor.main) {
        setStatusBar(color: color)
        contentView.addSubview(navigationView)
        navigationView.snp.makeConstraints { (maker) in
            maker.top.equalTo(statusBarView.snp.bottom)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(44)
        }
        navigationView.backgroundColor = color
        let leftView = UIView()
        navigationView.addSubview(leftView)
        leftView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(0)
            maker.width.equalTo(80)
            maker.height.equalTo(44)
        }
        leftView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(16)
        }
        backBtn.isUserInteractionEnabled = true
        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = .black
            navigationView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (maker) in
                maker.center.equalToSuperview()
            }
        }
    }
    
    override func back() {
        if hasFold {
            unFoldContentView()
            return
        }
        super.back()
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
        hasFold = true
        self.foldContentView()
    }

    func foldContentView() {
        UIView.animate(withDuration: 1) {
            self.leftBarView.alpha = 1
            self.contentViewLeading.constant = self.leftBarViewWidth
        } completion: { (result) in
            self.contentView.setAnchor(point: CGPoint(x: 0, y: 0.5))
            UIView.animate(withDuration: 3) {
                let transform3D: CATransform3D = CATransform3DMakeRotation(CGFloat.pi / 3 , 0, 1, 0)
                self.contentView.layer.transform = self.CATransform3DPerspect(t: transform3D, center: .zero, idz: 600)
                
            } completion: { (result) in
                
            }
        }
    }
    
    func unFoldContentView() {
        self.contentView.setAnchor(point: CGPoint(x: 0.5, y: 0.5))
        
        UIView.animate(withDuration: 2) {
            self.leftBarView.alpha = 0
            self.contentViewLeading.constant = 0
//          self.contentView.setAnchor(point: CGPoint(x: 0, y: 0.5))
            let transform3D: CATransform3D = CATransform3DMakeRotation(0, 0, 1, 0)
            self.contentView.layer.transform = self.CATransform3DPerspect(t: transform3D, center: .zero, idz: 600)
        } completion: { (result) in
            
            self.hasFold = false
        }
        
    }
    
    func CATransform3DMakePerspective(center:CGPoint, idz:CGFloat) -> CATransform3D {
        let transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0)
        let transback = CATransform3DMakeTranslation(center.x, center.y, 0)
        var scale = CATransform3DIdentity
        scale.m34 = -1.0 / idz
        return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transback)
    }

    func CATransform3DPerspect(t:CATransform3D, center:CGPoint, idz:CGFloat) -> CATransform3D {
        return CATransform3DConcat(t, CATransform3DMakePerspective(center: center, idz: idz))
    }
}
