//
//  UIImageView+URL.swift
//  diyplayer
//
//  Created by sidney on 2019/7/15.
//  Copyright © 2019 sidney. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFrom(url: URL, isCircle: Bool = false, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                if isCircle {
                    self.image = image.toCircle()
                } else {
                    self.image = image
                }
                
            }
            }.resume()
    }
    func loadFrom(link: String, isCircle: Bool = false, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            return
        }
        loadFrom(url: url, isCircle: isCircle, contentMode: mode)
    }
    
}
