//
//  UIViewController.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import UIKit

class OrientationController: UIViewController {
    var orientation: UIInterfaceOrientationMask = .all

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return orientation
    }
}
