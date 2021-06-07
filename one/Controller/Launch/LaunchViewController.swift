//
//  LaunchViewController.swift
//  one
//
//  Created by sidney on 2021/3/21.
//

import UIKit

class LaunchViewController: BaseViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabelCircleView: UIView!
    var countdownTimer: Timer!
    var countdownSeconds = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = "\(countdownSeconds)"
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if self.countdownSeconds > 0 {
                self.countdownSeconds -= 1
                self.timeLabel.text = "\(self.countdownSeconds)"
            } else {
                self.countdownTimer.invalidate()
                self.ignoreAd(UIButton())
            }
        }
        
        
        // 倒计时动画
        let layer = CAShapeLayer()
        let path = CGMutablePath()
        let center = timeLabelCircleView.frame.width / 2
        path.addArc(center: CGPoint(x: center, y: center), radius: 20, startAngle: -.pi / 2, endAngle: .pi * 3 / 2, clockwise: false)
        layer.path = path
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 1
        layer.fillColor = UIColor.clear.cgColor

        timeLabelCircleView.layer.addSublayer(layer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = CFTimeInterval(countdownSeconds)
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        pathAnimation.repeatCount = 1
        layer.add(pathAnimation, forKey: "strokeEndAnimation")
    }


    @IBAction func ignoreAd(_ sender: UIButton) {
        countdownTimer.invalidate()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.cancelLaunchWindow()
        delay(2) {
            appDelegate.rootVc?.drawerVc.tabbarVc?.showMusicControlBar()
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
