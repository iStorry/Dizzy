//
//  UIColor+Extensions.swift
//  Dizzy
//
//  Created by ジャティン on 2019/11/15.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit

public extension UIColor {
    func hexString(from color: UIColor?) -> String? {
        let data = color?.cgColor.components
        return String(format: "#%02lX%02lX%02lX", lroundf(Float((data?[0] ?? 0.0) * 255)), lroundf(Float((data?[1] ?? 0.0) * 255)), lroundf(Float((data?[2] ?? 0.0) * 255)))
    }

    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }

    static let error: UIColor = {
        return UIColor(red: 0.84, green: 0.20, blue: 0.20, alpha: 1.00)
    }()

}
