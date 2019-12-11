//
//  Liquid.swift
//  Small World
//
//  Created by ジャティン on 2019/07/01.
//  Copyright © 2019 Crafts Inc. All rights reserved.
//

import UIKit

/// Liquid View
class LiquidView: UIView {
    // Liquid View
    let liquidView = UIView()
    // Shape View
    let shapeView = UIImageView()

    /// Initialize
    ///
    /// - Parameter frame: CGRect
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// Initialize
    ///
    /// - Parameter aDecoder: NSCoder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup(_ image: UIImage, _ color: UIColor) {
        backgroundColor = UIColor.darkGray
        liquidView.backgroundColor = color
        shapeView.contentMode = .scaleAspectFit
        shapeView.image = image
        addSubview(liquidView)
        mask = shapeView
        layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        liquidView.frame = bounds
        shapeView.frame = bounds
    }

    func reset() {
        liquidView.frame.origin.y = bounds.height
    }

    func animate() {
        reset()
        UIView.animate(withDuration: 1) { [weak self] in
            self?.liquidView.frame.origin.y = 0
        }
    }

}
