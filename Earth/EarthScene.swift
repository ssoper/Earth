//
//  EarthScene.swift
//  Earth
//
//  Created by Soper, Sean on 4/22/16.
//  Copyright © 2016 The Washington Post. All rights reserved.
//

import UIKit
import SceneKit

struct Location {
    var name: String?
    var latitude: Double?
    var longitude: Double?

    func radians(degrees: Double) -> Double {
        return Double((degrees*M_PI)/180)
    }

    var x: Float? {
        if let latitude = latitude, longitude = longitude {
            return Float(cos(radians(latitude)) * cos(radians(longitude)) * 1.0)
        }

        return nil
    }

    var y: Float? {
        if let latitude = latitude, longitude = longitude {
            return Float(cos(radians(latitude)) * sin(radians(longitude)) * 1.0)
        }

        return nil
    }

    var z: Float? {
        if let latitude = latitude {
            return Float(sin(radians(latitude)) * 1.0)
        }

        return nil
    }
}

class EarthScene: SCNScene {

    var sphereNode: SCNNode?
    var lightNode: SCNNode?
    var night = false

    override init() {
        super.init()

        background.contents = UIImage(named: "starfield")

        let sphereGeometry = SCNSphere(radius: 1.0)
        sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "earth at day")
        if let sphereNode = sphereNode {
            rootNode.addChildNode(sphereNode)
        }

        addLight()
        addAnimation()

        let dc = Location(name: "Washington, D.C.", latitude: 38.98, longitude: -77.03)
        if let x = dc.x, y = dc.y, z = dc.z {
            let secondSphere = SCNSphere(radius: 0.05)
            let secondNode = SCNNode(geometry: secondSphere)
            secondNode.geometry?.firstMaterial?.diffuse.contents = UIColor.redColor()
            secondNode.position = SCNVector3(x: x, y: y, z: z)
            sphereNode?.addChildNode(secondNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addLight() {
        lightNode?.removeFromParentNode()

        let light = SCNLight()
        light.type = SCNLightTypeDirectional
        lightNode = SCNNode()

        if let lightNode = lightNode {
            lightNode.light = light
            lightNode.position = SCNVector3(x: -1.5, y: 1.5, z: 4.5)
            rootNode.addChildNode(lightNode)
        }
    }

    func addAnimation() {
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 0, z: 0, w: 0))
        spin.toValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(2*M_PI)))
        spin.duration = 30
        spin.repeatCount = .infinity
        sphereNode?.addAnimation(spin, forKey: "spin around")
    }

    func switchImage() {
        guard let sphereNode = sphereNode else {
            return
        }

        sphereNode.pauseAnimationForKey("spin around")
        sphereNode.removeAnimationForKey("spin around")

        let delayInSeconds: Int64 = Int64(0.25 * Double(NSEC_PER_SEC))
        let popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds)

        dispatch_after(popTime, dispatch_get_main_queue()) {
            if self.night {
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "earth at day")
                self.night = false
            } else {
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "earth at night")
                self.night = true
            }

            self.addAnimation()
        }
    }

}
