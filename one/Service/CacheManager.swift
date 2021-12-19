//
//  CacheManager.swift
//  one
//
//  Created by sidney on 6/1/21.
//

import Foundation
import SDWebImage
import SceneKit
import WebKit

class CacheManager {
    static let shared = CacheManager()
    
    var refreshHeaderImages: [UIImage] = []
    var imageInfos: [String: ImageInfo] = [:]
    var sceneViews: [SCNView] = []
    var webViews: [WKWebView] = []
    
    private init() {
//        let webView = WKWebView()
//        self.webViews.append(webView)
        
//        for _ in [0...2] {
//            let sceneView = SCNView()
//            let scene = SCNScene(named: "BrickLandspeeder4501.obj")
//            sceneView.scene = scene
//            self.sceneViews.append(sceneView)
//        }
    }
    
    private func getImagesInfo(urls: [String], callback: @escaping () -> Void) {
        let notCacheUrls = urls.filter { (url) -> Bool in
            return !self.imageInfos.keys.contains(url)
        }
        if notCacheUrls.count == 0 {
            callback()
            return
        }
        
    }
    
    func preCache(urlstrs: [String], callback: (() -> Void)?) {
        var urls: [URL] = []
        for urlstr in urlstrs {
            if let url = URL(string: urlstr) {
                urls.append(url)
            }
        }
        SDWebImagePrefetcher.shared.prefetchURLs(urls) { noOfFinishedUrls, noOfTotalUrls in
            
        } completed: { noOfFinishedUrls, noOfSkippedUrls in
            if let callback = callback {
                callback()
            }
        }

    }
    
    func getRefreshHeaderImages() {
        self.refreshHeaderImages = UIImage.getImagesFromGif(name: "refresh") ?? []
    }
    
    func deleteFile(willDeleteCacheKey: String) -> Bool {
        // 一定要用path，而不是absoluteString，因为后者包含file://协议头
        let path = FileDownloader.getFileUrl(originUrlStr: willDeleteCacheKey).path
        if !FileManager.default.fileExists(atPath: path) {
            print("文件不存在")
            return false
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            Storage.mediaCache[willDeleteCacheKey] = ""
            return true
        } catch let error as NSError {
            print(error)
            return false
        }
    }
}
