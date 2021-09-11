# Dplayer

[![Version](https://img.shields.io/cocoapods/v/Dplayer.svg?style=flat)](https://cocoapods.org/pods/Dplayer)
[![License](https://img.shields.io/cocoapods/l/Dplayer.svg?style=flat)](https://cocoapods.org/pods/Dplayer)
[![Platform](https://img.shields.io/cocoapods/p/Dplayer.svg?style=flat)](https://cocoapods.org/pods/Dplayer)

## Example

![1321631350185_ pic](https://user-images.githubusercontent.com/11461723/132942357-ed333684-cc30-45bd-b450-cda115d92705.jpg)
![1331631350185_ pic](https://user-images.githubusercontent.com/11461723/132942362-a3538b41-a33e-4d71-a1a2-854fc67b9cb7.jpg)
![1341631350186_ pic](https://user-images.githubusercontent.com/11461723/132942365-5b62dc60-4c49-4216-af92-be99cb218866.jpg)
![1351631350187_ pic](https://user-images.githubusercontent.com/11461723/132942366-99bc6af5-059d-4ec4-afff-44b2726fae63.jpg)


To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
`iOS 10 or newer`

## Installation

Dplayer is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'Dplayer'
```

## How to use it

### Basic video play

This lib support playing videos that system supports natively.
```
/// VC: DplayerDelegate
let diyPlayerView = DplayerView(frame: CGRect(x: 0, y: 100, width: SCREEN_WIDTH, height: height))
diyPlayerView.delegate = self
diyPlayerView.bottomProgressBarViewColor = UIColor.red
view.addSubview(diyPlayerView)
diyPlayerView.playUrl(url: videoUrl)
```

### Picture in Picture mode

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

### Background audio mode

If you want to stay player play when app is in background: 
1. Ensure you have enabled Background Audio mode in app capabilities configuration.
2. You need to do something as follow in AppDelegate: 
```
class AppDelegate: UIResponder, UIApplicationDelegate {
    var currentPlayer: AVPlayer?
    var currentPlayerLayer: AVPlayerLayer?
    func applicationDidEnterBackground(_ application: UIApplication) {

        // 保持后台播放
        self.currentPlayerLayer?.player = nil
    }
    func applicationWillEnterForeground(_ application: UIApplication) {

        // 恢复播放器画面
        self.currentPlayerLayer?.player = self.currentPlayer
    }
}

// And set the currentPlayer and currentPlayerLayer when player is set to play.

appDelegate.currentPlayer = diyPlayerView.player
appDelegate.currentPlayerLayer = diyPlayerView.playerLayer

```

### Danmaku

If you want to display danmaku(barrage) over the video player, you can use the danmu service of the player.
Example code:
```
/// 视频准备播放时的代理
func readyToPlay(totalTimeSeconds: Float) {
    var danmus: [DanmuModel] = []
    let colors: [UIColor] = [.white, .yellow, .red, .blue, .green]
    let fontSizes: [CGFloat] = [17.0, 14.0]
    for i in 0..<3000 {
        var danmu = DanmuModel()
        danmu.id = "\(i + 1)"
        danmu.time = Float(arc4random() % UInt32(totalTimeSeconds)) + (Float(arc4random() % UInt32(9)) / 10)
        danmu.content = "第\(danmu.time)秒弹幕"
        danmu.color = colors[Int(arc4random() % UInt32(5))].withAlphaComponent(0.7)
        danmu.fontSize = fontSizes[Int(arc4random() % UInt32(2))]
        if i % 500 == 0 {
            danmu.isSelf = true
        }
        danmus.append(danmu)
    }
    var danmuConfig = DanmuConfig()
    danmuConfig.maxChannelNumber = 8
    self.diyPlayerView.danmu.danmus = danmus
    self.diyPlayerView.danmu.danmuConfig = danmuConfig
}
```


## Author

sidney, 516202795@qq.com

## License

Dplayer is available under the MIT license. See the LICENSE file for more info.
