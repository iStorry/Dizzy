//
//  UIBarButtonItem+Badge.swift
//  Small World
//
//  Created by ジャティン on 2019/10/09.
//  Copyright © 2019 Crafts Inc. All rights reserved.
//

import UIKit

public class BadgedButtonItem: UIBarButtonItem {

    func setBadge(with value: Int) {
         badgeValue = value
    }

    var badgeValue: Int? {
        didSet {
            if let value = badgeValue, value > 0 {
                labelBadge.isHidden = false
                labelBadge.text = value.description
            } else {
                labelBadge.isHidden = true
            }
        }
    }

    var tapAction: (() -> Void)?

    let filterButton = UIButton()
    let labelBadge = UILabel()

    override init() {
        super.init()
        setup()
    }

    init(with image: UIImage?) {
        super.init()
        setup(image: image)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup(image: UIImage? = nil) {
        filterButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        filterButton.adjustsImageWhenHighlighted = false
        filterButton.setImage(image, for: .normal)
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20)
        filterButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        labelBadge.frame = CGRect(x: 36, y: 4, width: 15, height: 15)
        labelBadge.backgroundColor = .red
        labelBadge.clipsToBounds = true
        labelBadge.layer.cornerRadius = 7
        labelBadge.textColor = UIColor.white
        labelBadge.font = UIFont.systemFont(ofSize: 10)
        labelBadge.textAlignment = .center
        labelBadge.isHidden = true
        labelBadge.minimumScaleFactor = 0.1
        labelBadge.adjustsFontSizeToFitWidth = true
        filterButton.addSubview(labelBadge)
        customView = filterButton
    }

    @objc func buttonPressed() {
        if let action = tapAction {
            action()
        }
    }

}
