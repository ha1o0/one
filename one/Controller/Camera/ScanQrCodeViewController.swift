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

class ScanQrCodeViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var session: AVCaptureSession!
    var scanImageView: UIImageView!
    var isHandlePhoto = false
    
    lazy var containerView: UIView = {
        let _containerView = UIView()
//        _containerView.layer.borderWidth = 1
//        _containerView.layer.borderColor = UIColor.blue.cgColor
        return _containerView
    }()
    
    lazy var scanLineView: UIImageView = {
        let _scanLineView = UIImageView()
        _scanLineView.alpha = 0
        _scanLineView.image = UIImage(named: "QRCodeScanLine")
        return _scanLineView
    }()
    
    lazy var pictureBtn: UIButton = {
        let _pictureBtn = UIButton()
        _pictureBtn.tintColor = .white
        _pictureBtn.setTitle("", for: .normal)
        _pictureBtn.setImage(UIImage(systemName: "photo"), for: .normal)
        _pictureBtn.imageView?.contentMode = .scaleAspectFit
        _pictureBtn.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        _pictureBtn.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        return _pictureBtn
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "扫描二维码"
        setCustomNav(color: UIColor.black)
        setupView()
        if !hasCameraPermission {
            self.view.makeToast("对不起，请到设置中允许应用访问相机")
            return
        }
        // 主队列异步执行
        DispatchQueue.main.async {
            self.loadScanView()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.session.isRunning {
            self.session.stopRunning()
        }
    }
    
    func setupView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (maker) in
            maker.top.equalTo(navigationView.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        containerView.addSubview(scanLineView)
        scanLineView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(20)
        }
        containerView.addSubview(pictureBtn)
        pictureBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-100)
        }
    }
    
    func loadScanView() {
        let device: AVCaptureDevice = AVCaptureDevice.default(for: .video)!
        do {
            let input: AVCaptureDeviceInput = try AVCaptureDeviceInput.init(device: device)
            let output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
            print(containerView.frame)
//            output.rectOfInterest = containerView.frame
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            self.session = AVCaptureSession()
            self.session.sessionPreset = .high
            self.session.addInput(input)
            self.session.addOutput(output)
            
            output.metadataObjectTypes = output.availableMetadataObjectTypes
            
            let preViewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: session)
            preViewLayer.videoGravity = .resizeAspectFill
            preViewLayer.frame = containerView.bounds
            containerView.layer.insertSublayer(preViewLayer, at: 0)
            
            self.session.startRunning()
            
            UIView.animateKeyframes(withDuration: 3, delay: 0, options: .repeat) {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1 / 6) {
                    self.scanLineView.alpha = 1
                }
                UIView.addKeyframe(withRelativeStartTime: 5 / 6, relativeDuration: 1 / 6) {
                    self.scanLineView.alpha = 0
                }
                self.scanLineView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.containerView.frame.height)
            } completion: { (result) in
                print("animation result: \(result)")
            }
        } catch let error {
            print(error)
        }
    }
    
    @objc func selectPhoto() {
        if !hasPhotoLibraryPermission {
            self.view.makeToast("对不起，请到设置中允许应用访问相册")
            return
        }
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.navigationBar.tintColor = .main
        imagePickerVc.delegate = self
        self.present(imagePickerVc, animated: true, completion: nil)
    }
    
    func resultFromQRCodeImage(image: UIImage) -> String {
        let context: CIContext = CIContext(options: nil)
        let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        let ciImage: CIImage = CIImage(cgImage: image.cgImage!)
        let features = detector.features(in: ciImage)
        if features.count == 0 {
            return ""
        }
        let feature: CIQRCodeFeature = features.first as! CIQRCodeFeature
        return feature.messageString ?? "no info"
    }
    
    /// AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let result = readableObject.stringValue else { return }
            self.toastQRContent(result)
        }

        dismiss(animated: true)
    }
    
    /// UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.isHandlePhoto = true
        self.dismiss(animated: true) {
            let image: UIImage = info[.originalImage] as! UIImage
            let result = self.resultFromQRCodeImage(image: image)
            self.toastQRContent(result)
        }
    }
    
    func toastQRContent(_ info: String) {
        // 震动提示
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.view.makeToast("扫描到的内容：\(info)")
    }
}

extension ScanQrCodeViewController {
    
}
