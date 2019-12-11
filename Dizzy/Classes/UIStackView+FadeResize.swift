//
//  UIStackView+FadeResize.swift
//  Small World
//
//  Created by Rafael Montilla on 11/25/19.
//  Copyright © 2019 Small World Inc. All rights reserved.
//

import UIKit

public extension UIStackView {
    func fadeResize(animations: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { [weak self] in
            self?.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: animations) { [weak self] _ in
                UIView.animate(withDuration: 0.2) {
                    self?.alpha = 1
                }
            }
        }
    }
}
