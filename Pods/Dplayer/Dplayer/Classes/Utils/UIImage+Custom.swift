//
//  UIImage+Custom.swift
//  diyplayer
//
//  Created by sidney on 2019/7/15.
//  Copyright © 2019 sidney. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    public class func getUIImageByName(_ name: String) -> UIImage? {
        let result = UIImage(named: name, in: getBundle(), compatibleWith: nil)
        return result ?? nil
    }
}
