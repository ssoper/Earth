//
//  Location.swift
//  Earth
//
//  Created by Sean Soper on 4/29/16.
//  Copyright © 2016 The Washington Post. All rights reserved.
//

import QuartzCore
import SceneKit

struct Location {
    let name: String
    let latitude: Double
    let longitude: Double

    func radians(degrees: Double) -> Double {
        return Double((degrees*M_PI)/180)
    }

    var x: Float {
        return Float(cos(radians(latitude)) * sin(radians(longitude)) * 6371)
    }

    var y: Float {
        return Float(sin(radians(latitude)) * 6371)
    }

    var z: Float {
        return Float(cos(radians(latitude)) * cos(radians(longitude)) * 6371)
    }
}

class LocationAnimation: NSObject {
    let location: Location
    let node: SCNNode

    init(location: Location, node: SCNNode) {
        self.location = location
        self.node = node
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        print("animation \(anim) finished \(flag)")

        let secondSphere = SCNSphere(radius: 100)
        let secondNode = SCNNode(geometry: secondSphere)
        secondNode.geometry?.firstMaterial?.diffuse.contents = UIColor.redColor()
        secondNode.position = SCNVector3(x: location.x, y: location.y, z: location.z)
        node.addChildNode(secondNode)
    }
}
