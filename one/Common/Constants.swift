 //
//  Constants.swift
//  diyplayer
//
//  Created by sidney on 2018/8/28.
//  Copyright © 2018年 sidney. All rights reserved.
//

import Foundation
import UIKit

let SECONDS_PER_MINUTE = 60
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let STATUS_BAR_HEIGHT = CGFloat(hasNotch ? 44.0 : 20.0)
let leftVcleftVcVisibleViewWidthPercent = CGFloat(0.85)
let STATUS_NAV_HEIGHT: CGFloat = hasNotch ? 88 : 64
let BOTTOM_EXTRA_HEIGHT: CGFloat = hasNotch ? 34 : 0
var COLLECTION_VIEW_FOOTER_HEIGHT: CGFloat {
    get {
        guard let tabbarVc = appDelegate.rootVc?.drawerVc.tabbarVc else {
            return 0
        }
        return tabbarVc.bottomBlurView.bounds.height
    }
 }
let RAND_IMAGES = [
    "https://is3-ssl.mzstatic.com/image/thumb/Music124/v4/00/67/0d/00670d8a-5674-4a9b-93c7-58c2de3151ef/source/600x600bb.jpg",
    "https://is1-ssl.mzstatic.com/image/thumb/Music128/v4/aa/d4/70/aad470fd-e8cd-88f6-c00c-c194ebbb783d/source/600x600bb.jpg",
    "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/83/8e/e8/838ee843-0bb8-398f-7dcd-c8116dd08497/source/600x600bb.jpg",
    "https://is3-ssl.mzstatic.com/image/thumb/Music124/v4/2a/86/be/2a86beed-8422-2d27-a474-67e489217f2a/source/600x600bb.jpg",
    "https://is4-ssl.mzstatic.com/image/thumb/Music124/v4/51/b8/0a/51b80a00-987b-d44d-5d77-e0eb8c77b55c/source/600x600bb.jpg",
    "https://is4-ssl.mzstatic.com/image/thumb/Music124/v4/c5/fa/96/c5fa9635-75a0-087a-03ae-f8601e2f98c9/source/600x600bb.jpg",
    "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/62/cd/75/62cd758c-f06a-e139-d8d4-984a7c139d0c/source/600x600bb.jpg",
    "https://is2-ssl.mzstatic.com/image/thumb/Music124/v4/42/cc/dd/42ccdde9-ad79-6892-3b39-36c374eafa97/source/600x600bb.jpg",
    "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/92/80/61/9280610f-593b-0961-ed84-e88148b17b31/source/600x600bb.jpg",
    "https://is1-ssl.mzstatic.com/image/thumb/Music118/v4/09/73/d3/0973d3a4-c77d-24e6-0d21-2e7a84d292c5/source/600x600bb.jpg",
    "https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/b8/19/d9/b819d9a3-0207-2725-68c5-6e5529b1e8b2/source/600x600bb.jpg",
    "https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/cd/b8/b3/cdb8b381-6f24-6c6b-b369-615b2dd5e14e/source/600x600bb.jpg",
    "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/2e/57/8c/2e578c02-c391-26f5-fb39-35c17a344f3a/source/600x600bb.jpg",
    "https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/97/a6/35/97a635ad-c653-2331-220a-96ceff005d98/source/600x600bb.jpg",
    "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/a0/0f/3f/a00f3f67-b888-9149-ea7e-2ba9f53c51d0/source/600x600bb.jpg",
    "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/0b/dd/20/0bdd2025-dd54-a92b-8ffa-21ad5b7d67d3/source/600x600bb.jpg",
    "https://is4-ssl.mzstatic.com/image/thumb/Music124/v4/c0/f9/2d/c0f92d7e-5d52-0f36-adf7-787d1910cad5/source/600x600bb.jpg",
    "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/a7/25/47/a72547ff-ddfb-199c-a2cd-322b5f695763/source/600x600bb.jpg",
    "https://is3-ssl.mzstatic.com/image/thumb/Music124/v4/4e/2f/fe/4e2ffede-9bdd-6ccf-45d5-8f9fa8429e00/source/600x600bb.jpg",
    "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/42/57/7e/42577e30-e629-c07e-98f0-201a4ffca0cf/source/600x600bb.jpg",
    "https://is3-ssl.mzstatic.com/image/thumb/Music124/v4/77/56/37/77563720-c2e3-d584-e030-69e6da668ec4/source/600x600bb.jpg",
    "https://is5-ssl.mzstatic.com/image/thumb/Music114/v4/54/44/50/544450ff-aaf4-79a9-1b3b-c52fb598f4fb/source/600x600bb.jpg",
    "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/a9/85/64/a9856465-eacc-b533-b127-9796607ddb08/source/600x600bb.jpg",
    "https://is5-ssl.mzstatic.com/image/thumb/Music115/v4/18/37/0d/18370d53-e146-a295-9da4-f772fbbde252/source/600x600bb.jpg",
    "https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/4c/90/b5/4c90b552-8b6d-c1f5-20ee-5cb1665a5c12/source/600x600bb.jpg",
    "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/d0/d1/f8/d0d1f881-cc97-0167-a6c2-65cd54f6eb49/source/600x600bb.jpg",
    "https://is3-ssl.mzstatic.com/image/thumb/Music114/v4/c2/c9/3d/c2c93de5-7e64-f98b-9247-bffa6076d47c/source/600x600bb.jpg",
    "https://is5-ssl.mzstatic.com/image/thumb/Music125/v4/03/26/12/032612ad-88f5-176f-1822-e6e19a642c5f/source/600x600bb.jpg",
]

var hasNotch: Bool {
    return (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) > 0
}
 
func modelIdentifier() -> String {
    if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
    var sysinfo = utsname()
    uname(&sysinfo) // ignore return value
    return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
}

