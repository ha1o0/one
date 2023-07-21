//
//  AVVideoCompositionBuilder.swift
//  Dplayer
//
//  Created by sidney on 2022/1/25.
//

import Foundation
import AVKit
import AVFoundation
import CoreImage

class AVVideoCompositionBuilder {
    static func buildVideoComposition(asset: AVAsset, avComposition: AVComposition) -> AVVideoComposition {
        var context: CIContext
        if #available(iOS 12.0, *) {
            context = CIContext(options: [.cacheIntermediates: false, .name: "videoComp"])
        } else {
            context = CIContext(options: nil)
        }
        let timeRange = CMTimeRange(start: .zero, duration: asset.duration)
        
        return AVMutableVideoComposition(asset: asset) { request in
            let source = request.sourceImage
            let time = Float((request.compositionTime - timeRange.start).seconds)
            let ciFilter = HDRIndicatorFilter()
            ciFilter.inputImage = source
            ciFilter.inputTime = time
            
            if let output = ciFilter.outputImage {
                request.finish(with: output, context: context)
            } else {
                request.finish(with: FilterError.failedToProduceOutputImage)
            }
        }
    }
}
