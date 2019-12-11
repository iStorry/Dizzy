//
//  Vibration.swift
//  Dizzy
//
//  Created by ジャティン on 2019/11/16.
//  Copyright © 2019 Me. All rights reserved.
//

import AVFoundation
import UIKit

public enum Vibration {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    case selection
    case oldSchool

    public func vibrate() {

      switch self {
      case .error:
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)

      case .success:
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

      case .warning:
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)

      case .light:
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

      case .medium:
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

      case .heavy:
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()

      case .selection:
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()

      case .oldSchool:
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
      }

    }

}
