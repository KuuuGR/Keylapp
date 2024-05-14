//
//  OrientationViewController.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import UIKit

class OrientationViewController: UIViewController {
    var orientationMask = UIInterfaceOrientationMask.all

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return orientationMask
    }

    func setOrientation(_ orientation: UIInterfaceOrientationMask) {
        orientationMask = orientation
        setNeedsUpdateOfSupportedInterfaceOrientations()
    }
}
