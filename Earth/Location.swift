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
    let radius: Double
    let elevation: Double

    init(_ name: String, _ latitude: Double, _ longitude: Double) {
        self.init(name, latitude, longitude, 0)
    }

    init(_ name: String, _ latitude: Double, _ longitude: Double, _ elevation: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
        radius = 6371
    }

    func radians(degrees: Double) -> Double {
        return Double((degrees*M_PI)/180)
    }

    var x: Float {
        return Float(cos(radians(latitude)) * sin(radians(longitude)) * (radius + elevation))
    }

    var y: Float {
        return Float(sin(radians(latitude)) * (radius + elevation))
    }

    var z: Float {
        return Float(cos(radians(latitude)) * cos(radians(longitude)) * (radius + elevation))
    }

    var node: SCNNode {
        let sphere = SCNSphere(radius: 100)
        let node = SCNNode(geometry: sphere)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.redColor()
        node.position = SCNVector3(x: x, y: y, z: z)

        return node
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

        node.addChildNode(location.node)
    }
}
