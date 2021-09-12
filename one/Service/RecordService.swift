//
//  RecordService.swift
//  one
//
//  Created by sidney on 2021/9/11.
//

import Foundation
import AVFoundation
import Toast_Swift

class RecordService {
    
    static let shared = RecordService()
    let session = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder!
    var audioUrl: URL?
    
    var isPermissionGranted = -1
    
    private init() {}
    
    func checkPermission(callback: @escaping () -> Void) {
        switch session.recordPermission {
        case .granted:
            self.isPermissionGranted = 1
            callback()
            break
        case .denied:
            self.isPermissionGranted = 0
            break
        case .undetermined:
            session.requestRecordPermission { (result) in
                self.isPermissionGranted = result ? 1 : 0
                if (self.isPermissionGranted == 1) {
                    callback()
                }
            }
            break
        default:
            break
        }
    }
    
    func getFileUrl(name: String) -> URL {
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folder = documentsDirectoryURL.appendingPathComponent("record")
        if !FileManager.default.fileExists(atPath: folder.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print(error)
            }
        }
        let destinationUrl = folder.appendingPathComponent(name)
        return destinationUrl
    }
    
    func startRecord(view: UIView, fileName: String) {
        if (self.isPermissionGranted == 0) {
            view.makeToast("请到设置中允许录音权限")
            return
        }
        
        self.checkPermission {
            self.startRecord(fileName: fileName)
        }
    }
    
    func startRecord(fileName: String) {
        if (MusicService.shared.isPlaying) {
            MusicService.shared.pause()
        }
        delay(0.2) {
            let fileUrl = self.getFileUrl(name: "\(fileName).wav")
            self.audioUrl = fileUrl
            do {
                try self.session.setActive(false, options: .notifyOthersOnDeactivation)
                try self.session.setCategory(AVAudioSession.Category.playAndRecord, options: [.defaultToSpeaker, .mixWithOthers])
                try self.session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatLinearPCM),
                    AVSampleRateKey: 16000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                self.audioRecorder = try AVAudioRecorder(url: fileUrl, settings: settings)
                self.audioRecorder.isMeteringEnabled = true
                self.audioRecorder.prepareToRecord()
                self.audioRecorder.record()
            }
            catch let error {
                print(error)
            }
        }
        
    }
    
    func stopRecord() -> URL? {
        if (self.audioRecorder == nil || !audioRecorder.isRecording) {
            return nil
        }
        self.audioRecorder.stop()
        self.audioRecorder = nil
        return self.audioUrl
    }
}
