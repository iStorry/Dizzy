//
//  Indicator.swift
//  Small World
//
//  Created by ジャティン on 2019/08/29.
//  Copyright © 2019 Crafts Inc. All rights reserved.
//

import UIKit

class Indicator {
    static let shared = Indicator()
    private init() {}
    private var container: UIView = UIView()
    private var loading: UIView = UIView()
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func attachIndicator(with view: UIView) {
        container.frame = view.frame
        //container.center = view.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)

        loading.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loading.center = view.center
        loading.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loading.clipsToBounds = true
        loading.layer.cornerRadius = 10

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .large
        activityIndicator.center = CGPoint(x: loading.frame.size.width / 2, y: loading.frame.size.height / 2)

        loading.addSubview(activityIndicator)
        container.addSubview(loading)
        view.addSubview(container)

        container.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
    }

    func startIndicator() {
        activityIndicator.startAnimating()
    }

    func stopIndicator() {
        activityIndicator.stopAnimating()
    }

    func UIColorFromHex(rgbValue: UInt32, alpha: Double=1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }

}
