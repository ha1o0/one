//
//  ScanQrCodeViewController.swift
//  one
//
//  Created by sidney on 2021/4/27.
//

import UIKit
import AVKit
import AVFoundation
import Toast_Swift
import Photos

class ScanQrCodeViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate {

    var session: AVCaptureSession!
    var scanImageView: UIImageView!
    var isHandlePhoto = false
    var hasCameraPermission: Bool = {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == AVAuthorizationStatus.authorized || authStatus == AVAuthorizationStatus.notDetermined {
            return true
        }
        return false
    }()
    var hasPhotoLibraryPermission: Bool = {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == PHAuthorizationStatus.authorized || authStatus == PHAuthorizationStatus.notDetermined {
            return true
        }
        return false
    }()
    var scanRectOfInterest: CGRect = {
        let navStatusHeight = 44 + STATUS_BAR_HEIGHT
        return CGRect(x: 0, y: navStatusHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - navStatusHeight)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "扫描二维码"
        setCustomNav(color: UIColor.black)
        if !hasCameraPermission {
            self.view.makeToast("对不起，请到设置中允许应用访问相机")
            return
        }
        self.loadScanView()
    }
    
    
    func loadScanView() {
        let device: AVCaptureDevice = AVCaptureDevice.default(for: .video)!
        do {
            let input: AVCaptureDeviceInput = try AVCaptureDeviceInput.init(device: device)
            let output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
            output.rectOfInterest = scanRectOfInterest
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            self.session = AVCaptureSession()
            self.session.sessionPreset = .high
            self.session.addInput(input)
            self.session.addOutput(output)
            
            output.metadataObjectTypes = [.qr]
            
            let preViewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: session)
            preViewLayer.videoGravity = .resizeAspectFill
            view.layer.insertSublayer(preViewLayer, at: 0)
            
            self.session.startRunning()
        } catch let error {
            print(error)
        }
    }
    
//    func resultFromQRCodeImage(image: UIImage) -> String {
//        let context: CIContext = CIContext(options: nil)
//        let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
//        let ciImage: CIImage = CIImage(cgImage: image.cgImage!)
//        let features = detector.features(in: ciImage)
//        if features.count == 0 {
//            return ""
//        }
//        let feature: CIQRCodeFeature = features.first
//        return feature.messageString
//    }
    
    /// AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            self.session.stopRunning()
            let metadataObject: AVMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            print(metadataObject.stringValue ?? "error")
        }
    }
    
    /// UIImagePickerControllerDelegate
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        self.isHandlePhoto = true
//        self.dismiss(animated: true) {
//            let image: UIImage = info[.originalImage] as! UIImage
//            let result = self.resultFromQRCodeImage(image: image)
//            print(result)
//        }
//    }
}

extension ScanQrCodeViewController {
    
}
