//
//  LaunchViewController.swift
//  one
//
//  Created by sidney on 2021/3/21.
//

import UIKit

class LaunchViewController: BaseViewController {

    @IBOutlet weak var timeLabel: UILabel!
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
        // Do any additional setup after loading the view.
    }


    @IBAction func ignoreAd(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.cancelLaunchWindow()
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
