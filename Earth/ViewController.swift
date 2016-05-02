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

    @IBOutlet var overlay: UIView!
    @IBOutlet var newspaper: UIView!

    var scnView: SCNView?

    override func viewDidLoad() {
        super.viewDidLoad()

        scnView = self.view as? SCNView
        scnView?.scene = EarthScene()
        scnView?.backgroundColor = UIColor.blackColor()
//        scnView.autoenablesDefaultLighting = true
        scnView?.allowsCameraControl = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

    @IBAction func handleTap(recognizer: UITapGestureRecognizer) {
        print("got a tap!")
        UIView.animateWithDuration(0.25) {
            var changeInY = 0
            if self.overlay.frame.origin.y == 0 {
                changeInY = -50
            }

            self.overlay.frame = CGRectMake(0, CGFloat(changeInY), self.overlay.frame.width, self.overlay.frame.height)
        }

        // TODO
//        UIView.setAnimationTransition(.CurlDown, forView: newspaper, cache: false)
    }

    @IBAction func switchChanged(sender: UISwitch) {
        if let scene = scnView?.scene as? EarthScene {
            scene.switchImage()
        }
        print("switch changed")
    }
}

