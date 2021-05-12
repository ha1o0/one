//
//  MapViewController.swift
//  one
//
//  Created by sidney on 2021/4/14.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let mapTypes: [MKMapType] = [.standard, .satellite, .hybrid]
    var currentMapType = 0
    let locaionService = LocationService.shared
    let objectAnnotation = MKPointAnnotation()
    var hasGetLocation = false
    lazy var textInput: UITextField = {
        return UITextField()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "地图"
        setCustomNav()
        setTextField()
        //创建一个大头针对象
        self.mapView.addAnnotation(objectAnnotation)
        mapView.delegate = self
        locaionService.locationManager.delegate = self
        locaionService.requireLocation()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.getDeviceLocation()
            if self.hasGetLocation {
                timer.invalidate()
            }
        }
    }
    
    func getDeviceLocation() {
        if let center = locaionService.locationManager.location?.coordinate {
            print(center)
            self.setLocation(center: center, title: "上海市浦东新区", subtitle: "张江镇")
            self.hasGetLocation = true
        }
    }

    func setTextField() {
        view.addSubview(textInput)
        textInput.delegate = self
        textInput.backgroundColor = UIColor.scheduleMapPositionBkg
        textInput.layer.cornerRadius = 5
        textInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 30))
        textInput.leftViewMode = .always
        textInput.enablesReturnKeyAutomatically = false
        textInput.snp.makeConstraints { (maker) in
            maker.height.equalTo(45)
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(-20)
            maker.top.equalTo(navigationView.snp.bottom).offset(20)
        }
        textInput.returnKeyType = .done
        textInput.enablesReturnKeyAutomatically = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        search(textField.text ?? "")
        return true
    }
    
    @objc func search(_ text: String) {
        print(text)
        let coordinatesString = text.split(separator: ",")
        guard let newLatitude = Double(coordinatesString[0]), let newLongtitude = Double(coordinatesString[1]) else { return }
        let newCenter = CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongtitude)
        self.setLocation(center: newCenter)
    }
    
    @IBAction func plusMap(_ sender: UIButton) {
        back()
    }
    
    @IBAction func minusMap(_ sender: UIButton) {
        mapView.mapType = mapTypes[currentMapType]
        currentMapType += 1
        if currentMapType == mapTypes.count {
            currentMapType = 0
        }
    }
    
    @IBAction func currentMap(_ sender: UIButton) {
        getDeviceLocation()
    }
    
    func setLocation(center: CLLocationCoordinate2D, title: String = "", subtitle: String = "") {
        if center.latitude < -90 || center.latitude > 90 || center.longitude < -180 || center.longitude > 180 {
            self.view.makeToast("对不起，位置经纬度信息非法")
            return
        }
        let longtitude = center.longitude
        let latitude = center.latitude
        self.textInput.text = "\(latitude),\(longtitude)"
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let currentRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, span: currentLocationSpan)
        self.mapView.setRegion(currentRegion, animated: true)
        self.objectAnnotation.coordinate = CLLocation(latitude: center.latitude, longitude: center.longitude).coordinate
        if title.count == 0 && subtitle.count == 0 {
            objectAnnotation.title = "\(center.latitude)"
            objectAnnotation.subtitle = "\(center.longitude)"
            return
        }
        objectAnnotation.title = title
        objectAnnotation.subtitle = subtitle
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuserId = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserId)
            as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = true
            annotationView?.pinTintColor = UIColor.red
//            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("地图缩放级别发送改变时")
    }
     
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("地图缩放完毕")
//        self.setLocation(center: mapView.centerCoordinate)
    }
     
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        print("开始加载地图")
    }
     
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("地图加载结束")
    }
     
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("地图加载失败")
    }
     
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        print("开始渲染下载的地图块")
    }
     
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("渲染下载的地图结束")
    }
     
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        print("正在跟踪用户的位置")
    }
     
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("停止跟踪用户的位置")
    }
     
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("更新用户的位置")
    }
     
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        print("跟踪用户的位置失败")
    }
     
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode,
                 animated: Bool) {
        print("改变UserTrackingMode")
    }
     
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay)
        -> MKOverlayRenderer {
        print("设置overlay的渲染")
        return MKPolylineRenderer()
    }
     
    private func mapView(mapView: MKMapView,
                         didAddOverlayRenderers renderers: [MKOverlayRenderer]) {
        print("地图上加了overlayRenderers后调用")
    }
     
    /*** 下面是大头针标注相关 *****/
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        print("添加注释视图")
    }
     
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        print("点击注释视图按钮")
    }
     
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("点击大头针注释视图")
    }
     
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("取消点击大头针注释视图")
    }
     
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState,
                 fromOldState oldState: MKAnnotationView.DragState) {
        print("移动annotation位置时调用")
    }

}
