//
//  Composition.swift
//  Dplayer
//
//  Created by sidney on 2022/1/25.
//
import Foundation
import AVKit
import AVFoundation
import CoreImage

class AssetLoader {
    static func loadAsCompositions(asset: AVAsset) -> (AVComposition, AVVideoComposition) {
        let avComposition = AVMutableComposition()
        let timeRange = CMTimeRange(start: .zero, duration: asset.duration)
        let videoTrack = avComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        if let sourceTrack = asset.tracks(withMediaType: .video).first {
            try? videoTrack?.insertTimeRange(timeRange, of: sourceTrack, at: .zero)
        }
        
        let videoComposition = AVVideoCompositionBuilder.buildVideoComposition(asset: asset, avComposition: avComposition)
        
        return (avComposition, videoComposition)
    }
}

enum FilterError: Int, Error, LocalizedError {
    case failedToProduceOutputImage = -1_000_001
    
    var errorDescription: String? {
        switch self {
        case .failedToProduceOutputImage:
            return "CIFilter does not produce an output image"
        }
    }
}


class HDRIndicatorFilter: CIFilter {
    
    var inputImage: CIImage?
    var inputTime: Float = 0.0
    
    @available(iOS 11.0, *)
    static var kernel: CIColorKernel = {
        var bundle = getBundle()
        guard let url = bundle.url(forResource: "HDR", withExtension: "ci.metallib") else {
            fatalError("Unable to find the required Metal shader.")
        }
        do {
            let data = try Data(contentsOf: url)
            return try CIColorKernel(functionName: "HDRHighlight", fromMetalLibraryData: data)
        } catch {
            fatalError("Unable to load the kernel.")
        }
    }()
    
    override var outputImage: CIImage? {
        guard let input = inputImage else { return nil }
        if #available(iOS 11.0, *) {
            return HDRIndicatorFilter.kernel.apply(extent: input.extent, arguments: [input, inputTime])
        } else {
            return nil
        }
    }
}
