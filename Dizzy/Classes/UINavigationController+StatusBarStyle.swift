//
//  UINavigationController+StatusBarStyle.swift
//  Small World
//
//  Created by Rafael Montilla on 11/20/19.
//  Copyright © 2019 Small World Inc. All rights reserved.
//

import UIKit

public extension UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}
