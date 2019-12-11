//
//  CALayer+Extensions.swift
//  Dizzy
//
//  Created by ジャティン on 2019/11/15.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit

public extension CALayer {

    /// Extenstion for addBorders in CALayer
    ///
    /// - Parameters:
    ///   - edge: border side [.top, .bottom, .left, .right]
    ///   - color: border color
    ///   - thickness: border thickness
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            return border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)

        case UIRectEdge.bottom:
            return border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)

        case UIRectEdge.left:
            return border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)

        case UIRectEdge.right:
            return border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)

        default:
            break
        }
        border.backgroundColor = color.cgColor
        self.addSublayer(border)
    }
}
