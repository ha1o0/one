# Dplayer

[![Version](https://img.shields.io/cocoapods/v/Dplayer.svg?style=flat)](https://cocoapods.org/pods/Dplayer)
[![License](https://img.shields.io/cocoapods/l/Dplayer.svg?style=flat)](https://cocoapods.org/pods/Dplayer)
[![Platform](https://img.shields.io/cocoapods/p/Dplayer.svg?style=flat)](https://cocoapods.org/pods/Dplayer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
`iOS 10 or newer`

## Installation

Dplayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Dplayer'
```

## How to use it

This lib support playing videos that system supports natively.
```
/// VC: DplayerDelegate
func fullScreen() {

}

func exitFullScreen() {

}

let diyPlayerView = DplayerView(frame: CGRect(x: 0, y: 100, width: SCREEN_WIDTH, height: height))
diyPlayerView.layer.zPosition = 999
diyPlayerView.delegate = self
diyPlayerView.bottomProgressBarViewColor = UIColor.red
view.addSubview(diyPlayerView)
diyPlayerView.playUrl(url: videoUrl)
```

If you want to use picture in picture(pip), please check the example codes.
```
/// VC: DplayerDelegate
func pip() {
    pipController = self.diyPlayerView.getPipVc()
    pipController?.delegate = self
    self.diyPlayerView.startPip(pipController)
}


/// You'd better to record the play progress to UserDefaults, so that you can recover the origin progress when pip closed.
extension ViewController: AVPictureInPictureControllerDelegate {
    // 保持当前VC不被销毁
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        self.vc = self
        self.popForPip = true
        self.navigationController?.popViewController(animated: true)
    }

    // 销毁原VC，push新VC
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        self.vc = nil
        print("pictureInPictureControllerDidStopPictureInPicture")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        let newVc = ViewController()
        newVc.video = Storage.pipVideo
        appDelegate.rootVc.navigationController?.pushViewController(newVc, animated: true)
        print("pictureInPictureControllerDidStopPictureInPicture")
    }
}

```
## Author

sidney, 516202795@qq.com

## License

Dplayer is available under the MIT license. See the LICENSE file for more info.
