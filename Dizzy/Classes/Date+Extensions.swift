//
//  UIDevice+Extensions.swift
//  Dizzy
//
//  Created by ジャティン on 2019/11/15.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit

public enum DateFormat: String {
    case short = "yyyy.MM.dd"
    case dateTime = "yyyy.MM.dd HH:mm"
}

public extension Date {

    func toString(format: DateFormat = .short) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }

}
