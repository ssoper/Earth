//
//  EarthScene.swift
//  Earth
//
//  Created by Soper, Sean on 4/22/16.
//  Copyright © 2016 The Washington Post. All rights reserved.
//

import UIKit
import SceneKit

class EarthScene: SCNScene {

    override init() {
        super.init()

        let sphereGeometry = SCNSphere(radius: 1.0)
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "earth at day")
        self.rootNode.addChildNode(sphereNode)

        let light = SCNLight()
        light.type = SCNLightTypeDirectional
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: -1.5, y: 1.5, z: 4.5)
        self.rootNode.addChildNode(lightNode)

        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 0, z: 0, w: 0))
        spin.toValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(4*M_PI)))
        spin.duration = 30
        spin.repeatCount = .infinity
        sphereNode.addAnimation(spin, forKey: "spin around")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
