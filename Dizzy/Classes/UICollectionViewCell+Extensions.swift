//
//  UICollectionViewCell+Extensions.swift
//  Dizzy
//
//  Created by ジャティン on 2019/11/15.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit

// MARK: - This extension is created for handling UICollectionViewCell Animations in Project
public extension UICollectionViewCell {

    /// Call this function for bounce animation in collection view
    ///
    /// - Parameters:
    ///   - velocity: 10.0
    ///   - duration: 0.3
    ///   - scale: 0.8
    ///   - completion: true
    func anim(velocity: CGFloat = 10.0, duration: Double = 0.3, scale: CGFloat = 0.8, completion: @escaping (Bool) -> Void) {
        self.isUserInteractionEnabled = false
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: velocity, options: .allowUserInteraction, animations: {
            self.transform = .identity
        }, completion: { _ in
            self.isUserInteractionEnabled = true
            completion(true)
        })
    }
}
