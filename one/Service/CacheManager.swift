//
//  CacheManager.swift
//  one
//
//  Created by sidney on 6/1/21.
//

import Foundation
import SDWebImage

class CacheManager {
    static let shared = CacheManager()
    
    private init() {}
    
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
}
