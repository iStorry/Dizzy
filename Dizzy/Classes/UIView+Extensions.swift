//
//  UIView+Extensions.swift
//  Dizzy
//
//  Created by ジャティン on 2019/11/15.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit

public extension UIView {
    /**
     Fade in a view with a duration
     - parameter duration: custom animation duration
    */

    func fadeIn(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }

    /**
     Fade out a view with a duration
     - parameter duration: custom animation duration
     */

    func fadeOut(duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    /// Apply Gradient
    /// - Parameter colours: Colors [.red, .blue]
    func applyGradient(colours: [UIColor]) {
        drawGradient(colours: colours, locations: nil)
    }

    /// Draw Gradient Color
    /// - Parameter colours: [.red, .blue]
    /// - Parameter locations: Point
    private func drawGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        layer.insertSublayer(gradient, at: 0)
    }
    
    /// Extenstion for addBorders in UIView
    ///
    /// - Parameters:
    ///   - edge: border side [.top, .bottom, .left, .right] || [.all]
    ///   - color: border color
    ///   - thickness: border thickness
    func addBorder(edges: UIRectEdge, color: UIColor, thickness: CGFloat) {

        var borders = [UIView]()

        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }

        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]", options: [], metrics: ["thickness": thickness], views: ["top": top])
            )
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|", options: [], metrics: nil, views: ["top": top])
            )
            borders.append(top)
        }

        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]", options: [], metrics: ["thickness": thickness], views: ["left": left])
            )
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|", options: [], metrics: nil, views: ["left": left])
            )
            borders.append(left)
        }

        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|", options: [], metrics: ["thickness": thickness], views: ["right": right])
            )
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|", options: [], metrics: nil, views: ["right": right])
            )
            borders.append(right)
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|", options: [], metrics: ["thickness": thickness], views: ["bottom": bottom])
            )
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|", options: [], metrics: nil, views: ["bottom": bottom])
            )
            borders.append(bottom)
        }
    }
    
    func addSubviewScreenCenter() {
        if let keyWindow = UIApplication.topWindow() {
            keyWindow.addSubview(self)
        }
    }

    func removeFromWindowView() {
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }
}
