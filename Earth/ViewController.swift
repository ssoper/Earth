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
    @IBOutlet var contentView: UIView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var textView: UITextView!

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

        UIView.animateWithDuration(5.0) {
            self.textView.text = "The folks who live in and around the nation’s capital are veterans of everything from the Sept. 11 terrorist attacks to the mass shooting at the Washington Navy Yard. But in the past few months, cupboards have been shaking and dishes have been rattling as what appear to be V-22 Ospreys — massive, tilt-rotor aircraft that don’t look or sound like any of the zippy dragonfly helicopters we’re all used to — are hovering over Northern Virginia neighborhoods."
            self.locationLabel.text = "Washington, D.C."
            self.contentView.hidden = false
            UIView.setAnimationTransition(.CurlDown, forView: self.contentView, cache: true)
        }

    }

    @IBAction func switchChanged(sender: UISwitch) {
        if let scene = scnView?.scene as? EarthScene {
            scene.switchImage()
        }
        print("switch changed")
    }
}

