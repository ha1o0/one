//
//  BezierPathViewController.swift
//  one
//
//  Created by sidney on 4/12/21.
//

import UIKit

class BezierPathViewController: BaseViewController {

    lazy var scrollView = {
        return UIScrollView()
    }()
    lazy var contentView = UIView()
    lazy var firstView = UIView()
    lazy var secondView = UIView()
    lazy var coupon = UIView()
    lazy var circle = DoubleCircle(innerRadius: 10, outerLineWidth: 2, innerLineWidth: 1, outerColor: UIColor.main, innerColor: UIColor.main, isInnerEmpty: false, isOuterEmpty: true)
    var firstViewTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "贝塞尔曲线"
        setCustomNav()
        initScrollContentView()
        setupBezierView1()
        setupBezierView2()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 销毁定时器，防止内存泄露
        firstViewTimer.invalidate()
    }
    
    func initScrollContentView() {
        self.view.addSubview(scrollView)
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalTo(navigationView.snp.bottom)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.leading.trailing.equalTo(self.view)
        }
    }
    
    func setupBezierView1() {
        contentView.addSubview(firstView)
        firstView.backgroundColor = .lightGray
        let height = CGFloat(600)
        firstView.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalToSuperview()
            maker.height.equalTo(height)
        }
        let titleLabel = UILabel()
        titleLabel.text = "优惠券圆角、倒角绘制"
        firstView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(10)
        }

        firstView.addSubview(coupon)
        coupon.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(120)
            maker.top.equalToSuperview().offset(60)
            maker.width.equalTo(300)
        }
        
        let couponLeft = CouponLeftView()
        couponLeft.backgroundColor = .clear
        coupon.addSubview(couponLeft)
        couponLeft.snp.makeConstraints { (maker) in
            maker.top.leading.bottom.equalToSuperview()
            maker.width.equalTo(200)
        }
        let couponRight = CouponRightView()
        couponRight.backgroundColor = .clear
        coupon.addSubview(couponRight)
        couponRight.snp.makeConstraints { (maker) in
            maker.width.equalTo(100)
            maker.top.trailing.bottom.equalToSuperview()
            maker.leading.equalTo(couponLeft.snp.trailing)
        }
//        coupon.setAnchor(point: CGPoint(x: 0.2, y: 0.5))
        self.animateView1()
        
        circle.backgroundColor = .clear
        firstView.addSubview(circle)
        circle.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(firstView)
            maker.width.height.equalTo(50)
            maker.top.equalTo(coupon.snp.bottom).offset(300)
        }
        self.animateView2()
    }
    
    func setupBezierView2() {
        contentView.addSubview(secondView)
        secondView.backgroundColor = .lightText
        let height = CGFloat(600)
        secondView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(firstView.snp.bottom)
            maker.height.equalTo(height)
            maker.bottom.equalToSuperview()
        }
        
    }
    
    @objc func animateView1() {
        firstViewTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            UIView.animate(withDuration: 1) {
                self.coupon.transform = CGAffineTransform.identity.rotated(by: .pi / 12).translatedBy(x: 0, y: 50)
            } completion: { (result) in
                UIView.animate(withDuration: 1) {
                    self.coupon.transform = CGAffineTransform.identity.rotated(by: -.pi / 12).translatedBy(x: 0, y: 0)
                } completion: { (result) in

                }
            }
        }
    }
    
    @objc func animateView2() {
        
        // 圆环位置沿路径移动
        let keyFrameAniamtion = CAKeyframeAnimation(keyPath: "position")
        let mutablePath = CGMutablePath()
        mutablePath.move(to: CGPoint(x: 50, y: 300))
        mutablePath.addCurve(to: CGPoint(x: 300, y: 300), control1: CGPoint(x: 50, y: 200), control2: CGPoint(x: 200, y: 500))
        mutablePath.addLine(to: CGPoint(x: 50, y: 300))
        keyFrameAniamtion.path = mutablePath
        keyFrameAniamtion.duration = 3.0
        keyFrameAniamtion.fillMode = .backwards
        keyFrameAniamtion.repeatCount = Float.greatestFiniteMagnitude
        keyFrameAniamtion.isRemovedOnCompletion = false
        circle.layer.add(keyFrameAniamtion, forKey: "animation")
        
        
        let layer = CAShapeLayer()
        layer.path = mutablePath
        layer.strokeColor = UIColor.main.cgColor
        layer.lineWidth = 5
        layer.fillColor = nil
        firstView.layer.addSublayer(layer)
        
        // 路径直接描绘出来无动画
        let pathAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        pathAnimation.path = mutablePath
        pathAnimation.duration = 3.0
        pathAnimation.fillMode = .backwards
        pathAnimation.repeatCount = Float.greatestFiniteMagnitude
        pathAnimation.isRemovedOnCompletion = false

        // 路径描绘有动画
//        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        pathAnimation.duration = 3.0
//        pathAnimation.fromValue = 0
//        pathAnimation.toValue = 1.0
//        pathAnimation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(pathAnimation, forKey: "strokeEndAnimation")
    }
}
