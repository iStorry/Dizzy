//
//  ImageCell.swift
//  Small World
//
//  Created by ジャティン on 2019/08/08.
//  Copyright © 2019 Crafts Inc. All rights reserved.
//

#if canImport(Eureka)

import UIKit
import Eureka

public final class ImageCell: PushSelectorCell<UIImage> {
    public override func setup() {
        super.setup()

        accessoryType = .none
        editingAccessoryView = .none

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        accessoryView = imageView
        editingAccessoryView = imageView
    }

    public override func update() {
        super.update()

        selectionStyle = row.isDisabled ? .none : .default
        (accessoryView as? UIImageView)?.image = row.value ?? (row as? ImageRowProtocol)?.placeholderImage
        (editingAccessoryView as? UIImageView)?.image = row.value ?? (row as? ImageRowProtocol)?.placeholderImage
    }
}
#endif
