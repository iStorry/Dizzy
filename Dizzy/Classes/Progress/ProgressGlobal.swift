//
//  ProgressGlobal.swift
//  Small World
//
//  Created by ジャティン on 2019/07/08.
//  Copyright © 2019 Crafts Inc. All rights reserved.
//

import UIKit

public extension UIApplication {
    class func topViewController(base: UIViewController? = topWindow()?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    class func topWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

public extension UIView {

    private struct AssociatedKeys {
        static var Progress: Progress?
    }

    /** Set x Position */
    internal func setX(x: CGFloat) {
        var frame: CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    /** Set y Position */
    internal func setY(y: CGFloat) {
        var frame: CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    /** Set z Position */
    internal func setZ(z: CGFloat) {
        self.layer.zPosition = z
    }
    /** Set Width */
    internal func setWidth(width: CGFloat) {
        var frame: CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    /** Set Height */
    internal func setHeight(height: CGFloat) {
        var frame: CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }

    /** Get class of Progress. Make sure to attach progress first in this view. */
    internal var progress: Progress? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.Progress) as? Progress
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.Progress, newValue as Progress?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    func attachLoading() {
        let iprogress: Progress = Progress()
        iprogress.iprogressStyle = .vertical
        iprogress.indicatorStyle = .circleStroke
        iprogress.isShowModal = false
        iprogress.isShowCaption = false
        iprogress.boxSize = 25
        iprogress.boxColor = .clear
        iprogress.indicatorSize = 50
        iprogress.indicatorColor = .white
        iprogress.attachProgress(toViews: self)
    }

    /** Show the Progress directly from this view. */
    func showProgress() {
        if progress == nil {
            attachLoading()
        }
        self.progress?.show()
    }

    /** Stop the Progress directly from this view. */
    func dismissProgress() {
        if progress == nil {
            attachLoading()
        }
        self.progress?.dismiss()
    }

    /** Update the indicator style of Progress directly from this view. */
    func updateIndicator(style: NVActivityIndicatorType) {
        if progress == nil {
            attachLoading()
        }
        self.progress?.indicatorStyle = style
        self.progress?.indicatorView.type = style
        self.progress?.indicatorView.setUpAnimation()
    }

    /** Update the caption of Progress directly from this view. */
    func updateCaption(text: String) {
        if progress == nil {
            attachLoading()
        }
        progress?.captionView.text = text
        progress?.captionView.sizeToFit()
        let boxCenter = CGPoint(x: (progress?.boxView.frame.size.width)! / 2, y: (progress?.boxView.frame.size.height)! / 2)
        progress?.progressStyleSetting(boxCenter: boxCenter)
    }

    /** Update colors of Progress. Set nil if want not to change. */
    func updateColors(modalColor: UIColor?, boxColor: UIColor?, indicatorColor: UIColor?, captionColor: UIColor?) {
        if progress == nil {
            attachLoading()
        }
        if modalColor != nil {
            progress?.modalColor = modalColor!
            progress?.modalView.backgroundColor = modalColor
        }

        if boxColor != nil {
            progress?.boxColor = boxColor!
            progress?.boxView.backgroundColor = boxColor
        }

        if indicatorColor != nil {
            progress?.indicatorColor = indicatorColor!
            progress?.indicatorView.color = indicatorColor!
            progress?.indicatorView.setUpAnimation()
        }

        if captionColor != nil {
            progress?.captionColor = captionColor!
            progress?.captionView.textColor = captionColor
        }
    }
}

public extension Progress {

    func copy() -> Progress {
        let reinit = Progress()
        reinit.indicatorStyle = self.indicatorStyle
        reinit.iprogressStyle = self.iprogressStyle
        reinit.indicatorSize = self.indicatorSize
        reinit.alphaModal = self.alphaModal
        reinit.boxSize = self.boxSize
        reinit.boxCorner = self.boxCorner
        reinit.captionDistance = self.captionDistance
        reinit.isShowCaption = self.isShowCaption
        reinit.isShowModal = self.isShowModal
        reinit.isShowBox = self.isShowBox
        reinit.isBlurBox = self.isBlurModal
        reinit.isBlurBox = self.isBlurBox
        reinit.isTouchDismiss = self.isTouchDismiss
        reinit.modalColor = self.modalColor
        reinit.boxColor = self.boxColor
        reinit.captionColor = self.captionColor
        reinit.indicatorColor = self.indicatorColor
        reinit.captionSize = self.captionSize
        reinit.delegete = self.delegete
        return reinit
    }
}

internal class ProgressUtilities {

    internal static func blurEffect(view: UIImageView, corner: CGFloat) {
        let boxCenter = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = view.frame
        blurView.center = boxCenter
        blurView.alpha = 0.8
        blurView.backgroundColor = view.backgroundColor?.withAlphaComponent(0.5)
        blurView.contentView.addSubview(vibrancyView)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = corner
        view.insertSubview(blurView, at: 0)
    }

    internal static func getSizeUILabel(label: UILabel) -> CGSize {
        let uiLabel = UILabel(frame: CGRect(x: 0, y: 0, width: label.frame.width, height: .greatestFiniteMagnitude))
        uiLabel.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        uiLabel.adjustsFontSizeToFitWidth = true
        uiLabel.lineBreakMode = .byWordWrapping
        uiLabel.numberOfLines = label.numberOfLines
        uiLabel.text = label.text
        uiLabel.sizeToFit()
        return uiLabel.bounds.size
    }

    internal static func getXPercent(view: UIView, percent: CGFloat) -> CGFloat {
        return view.bounds.width - (view.bounds.width * ((100 - percent) / 100))
    }

    internal static func getYPercent(view: UIView, percent: CGFloat) -> CGFloat {
        return view.bounds.height - (view.bounds.height * ((100 - percent) / 100))
    }

    internal static func getWidthPercent(view: UIView, percent: CGFloat) -> CGFloat {
        return view.bounds.width * (percent / 100)
    }

    internal static func getHeightPercent(view: UIView, percent: CGFloat) -> CGFloat {
        return view.bounds.height * (percent / 100)
    }

    internal static func getWidthScreen() -> CGFloat {
        return UIScreen.main.bounds.width
    }

    internal static func getHeightScreen() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
