//
//  SceneKitViewController.swift
//  one
//
//  Created by sidney on 4/22/21.
//

import UIKit
import SceneKit
import QuartzCore   // for the basic animation

class SceneKitViewController: BaseViewController {

    var sceneView = SCNView()
    var sceneView2 = SCNView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SceneKit"
        setCustomNav()
        setup1()
        setup2()
        // Do any additional setup after loading the view.
    }

    func setup1() {
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.backgroundColor = .lightGray
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        view.addSubview(sceneView)
        sceneView.snp.makeConstraints { (maker) in
            maker.top.equalTo(navigationView.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(300)
        }

        // camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene.rootNode.addChildNode(cameraNode)

        // geometry object
        let torus = SCNTorus(ringRadius: 1, pipeRadius: 0.35)
        let torusNode = SCNNode(geometry: torus)
        scene.rootNode.addChildNode(torusNode)

        // configure the geometry object
        torus.firstMaterial?.diffuse.contents  = UIColor.red.withAlphaComponent(0.3)
        torus.firstMaterial?.specular.contents = UIColor.white
        torusNode.rotation = SCNVector4(x: 2.0, y: 2.0, z: 2.0, w: 1.0)

        // animate the rotation of the torus
//        let spin = CABasicAnimation(keyPath: "rotation.w") // only animate the angle
//        spin.toValue = 2.0 * Double.pi
//        spin.duration = 3
//        spin.repeatCount = HUGE // for infinity
//        torusNode.addAnimation(spin, forKey: "spin around")
    }

    
    func setup2() {
        view.addSubview(sceneView2)
        sceneView2.snp.makeConstraints { (maker) in
            maker.top.equalTo(sceneView.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(SCREEN_HEIGHT - 300 - 44 - STATUS_BAR_HEIGHT)
        }
        
        let scene = SCNScene(named: "BrickLandspeeder4501.obj")

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        scene?.rootNode.addChildNode(cameraNode)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.intensity = 100
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 5, z: 5)
        scene?.rootNode.addChildNode(lightNode)
        
        // 6: Creating and adding ambien light to scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.lightGray
        scene?.rootNode.addChildNode(ambientLightNode)
        
        // Allow user to manipulate camera
        sceneView2.allowsCameraControl = true
        sceneView2.backgroundColor = UIColor.scheduleMapPositionBkg
        sceneView2.cameraControlConfiguration.allowsTranslation = false
        sceneView2.scene = scene
        
    }
}
