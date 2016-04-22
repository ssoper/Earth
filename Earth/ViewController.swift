//
//  ViewController.swift
//  Earth
//
//  Created by Soper, Sean on 4/22/16.
//  Copyright © 2016 The Washington Post. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scnView = self.view as! SCNView
        scnView.scene = EarthScene()
        scnView.backgroundColor = UIColor.blackColor()
//        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

