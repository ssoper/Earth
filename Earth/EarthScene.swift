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

    var sphereNode: SCNNode?
    var lightNode: SCNNode?
    var night = false

    override init() {
        super.init()

        background.contents = UIImage(named: "starfield")

        let sphereGeometry = SCNSphere(radius: 6371)
        sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "earth at day")
        if let sphereNode = sphereNode {
            rootNode.addChildNode(sphereNode)
        }

        addLight()

        let dc = Location("Washington, D.C.", 38.9072, -77.0369, 500)
//        let paris = Location(name: "Paris, France", latitude: 48.8566, longitude: 2.3522)
        let goa = Location("Goa, India", 15.2993, 74.1240, 500)

        sphereNode?.addChildNode(dc.node)
//        sphereNode?.addChildNode(paris.node)
        sphereNode?.addChildNode(goa.node)

//        sphereNode?.addChildNode(lineBetweenNodeA(dc.node, nodeB: paris.node))
        sphereNode?.addChildNode(lineBetweenNodeA(dc.node, nodeB: goa.node))
//        addAnimation(dc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    func lineBetweenNodeA(nodeA: SCNNode, nodeB: SCNNode) -> SCNNode {
        let positions: [Float32] = [nodeA.position.x, nodeA.position.y, nodeA.position.z, nodeB.position.x, nodeB.position.y, nodeB.position.z]
        let positionData = NSData(bytes: positions, length: sizeof(Float32)*positions.count)
        let indices: [Int32] = [0, 1]
        let indexData = NSData(bytes: indices, length: sizeof(Int32) * indices.count)

        let source = SCNGeometrySource(data: positionData, semantic: SCNGeometrySourceSemanticVertex, vectorCount: indices.count, floatComponents: true, componentsPerVector: 3, bytesPerComponent: sizeof(Float32), dataOffset: 0, dataStride: sizeof(Float32) * 3)
        let element = SCNGeometryElement(data: indexData, primitiveType: SCNGeometryPrimitiveType.Line, primitiveCount: indices.count, bytesPerIndex: sizeof(Int32))

        let line = SCNGeometry(sources: [source], elements: [element])
        return SCNNode(geometry: line)
    }

    func addLight() {
        lightNode?.removeFromParentNode()

        let light = SCNLight()
        light.type = SCNLightTypeDirectional
        lightNode = SCNNode()

        if let lightNode = lightNode {
            lightNode.light = light
            lightNode.position = SCNVector3(x: -1.5, y: 1.5, z: 8000)
            rootNode.addChildNode(lightNode)
        }
    }

    func addAnimation(location: Location) {
        guard let node = sphereNode else {
            return
        }

        let offset = Double((abs(location.longitude)*M_PI)/180)
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 0, z: 0, w: 0))
        spin.toValue = NSValue(SCNVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(4*M_PI+offset)))
        spin.duration = 5
        spin.repeatCount = 1 //.infinity
        spin.fillMode = kCAFillModeForwards
        spin.removedOnCompletion = false
        spin.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        sphereNode?.addAnimation(spin, forKey: "spin around")
        spin.delegate = LocationAnimation(location: location, node: node)
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

            let dc = Location("Washington, D.C.", 38.9072, -77.0369)
            self.addAnimation(dc)
        }
    }

}
