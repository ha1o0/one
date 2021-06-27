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
    appDelegate.deviceOrientation = .landscapeRight
    let value = UIInterfaceOrientation.landscapeRight.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
}

func exitFullScreen() {
    appDelegate.deviceOrientation = .portrait
    let value = UIInterfaceOrientation.portrait.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
}

let diyPlayerView = DplayerView(frame: CGRect(x: 0, y: 100, width: SCREEN_WIDTH, height: height))
diyPlayerView.layer.zPosition = 999
diyPlayerView.delegate = self
view.addSubview(diyPlayerView)
diyPlayerView.playUrl(url: videoUrl)
```

## Author

sidney, 516202795@qq.com

## License

Dplayer is available under the MIT license. See the LICENSE file for more info.
