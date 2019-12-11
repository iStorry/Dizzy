//
//  Icons.swift
//  Small World
//
//  Created by ジャティン on 2019/06/27.
//  Copyright © 2019 Crafts Inc. All rights reserved.
//

import UIKit

public extension UIViewController {

    /// Default Icon Size
    var iconSize: CGSize {
        return CGSize(width: 20, height: 20)
    }

    /// Setting Icon
    ///
    /// - Returns: Setting FontType
    func settings() -> FontType {
        return .fontAwesomeSolid(.cog)
    }

    /// Share Icon
    ///
    /// - Returns: Share FontType
    func shareIcon() -> FontType {
        return .fontAwesomeSolid(.shareSquare)
    }

    /// Ellipsis Icon
    ///
    /// - Returns: Ellipsis FontType
    func ellipsisH() -> FontType {
        return .fontAwesomeSolid(.ellipsisH)
    }

    /// Chevron Right Icon
    ///
    /// - Parameter color: UIColor
    /// - Returns: Chevron UIImage
    func chevronRight(color: UIColor) -> UIImage {
        return UIImage.init(icon: .fontAwesomeSolid(.chevronRight), size: iconSize, textColor: color)
    }

    /// Clock Icon
    ///
    /// - Returns: Clock FontType
    func clock() -> FontType {
        return .fontAwesomeRegular(.clock)
    }

    /// Yen Icon
    ///
    /// - Returns: Yen FontType
    func yen() -> FontType {
        return .fontAwesomeSolid(.yenSign)
    }

    /// Map Marker
    ///
    /// - Returns: Map Marker FontType
    func mapMarker() -> FontType {
        return .fontAwesomeSolid(.mapMarkerAlt)
    }

    /// Camera UIImage With Default 25px Size
    var camera: UIImage {
        return UIImage.init(icon: .fontAwesomeSolid(.camera), size: CGSize(width: 25, height: 25))
    }

    /// List UIImage With Default 25px Size
    var list: UIImage {
        return UIImage.init(icon: .fontAwesomeSolid(.clipboardList), size: CGSize(width: 25, height: 25))
    }

    /// Edit UIImage With Default 25px Size
    var edit: UIImage {
        return UIImage.init(icon: .fontAwesomeSolid(.edit), size: CGSize(width: 25, height: 25))
    }

}
