//
//  OrientationViewController.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import UIKit
import SwiftUI

class OrientationViewController: UIViewController {
    var orientationMask = UIInterfaceOrientationMask.all

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return orientationMask
    }

    // Function to change the orientation
    func setOrientation(_ orientation: UIInterfaceOrientationMask) {
        orientationMask = orientation
        setNeedsUpdateOfSupportedInterfaceOrientations()
    }
}
