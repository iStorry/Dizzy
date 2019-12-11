//
//  Dizzy.swift
//  Small World
//
//  Created by ジャティン on 2019/07/29.
//  Copyright © 2019 Crafts Inc. All rights reserved.
//

import UIKit

//swiftlint:disable file_length
public extension UIImage {

    /**
     This init function sets the icon to UIImage
     
     - Parameter icon: The icon for the UIImage
     - Parameter size: CGSize for the icon
     - Parameter textColor: Color for the icon
     - Parameter backgroundColor: Background color for the icon
     
     - Since: 1.0.0
     */
    convenience init(icon: FontType, size: CGSize, textColor: UIColor = .black, backgroundColor: UIColor = .clear) {
        FontLoader.loadFontIfNeeded(fontType: icon)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let fontAspectRatio: CGFloat = 1.28571429
        let fontSize = min(size.width / fontAspectRatio, size.height)
        let font = UIFont(name: icon.fontName(), size: fontSize)
        assert(font != nil, icon.errorAnnounce())
        let attributes = [
            NSAttributedString.Key.font: font!,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.backgroundColor: backgroundColor,
            NSAttributedString.Key.paragraphStyle: paragraph
        ]
        let lineHeight = font!.lineHeight
        let attributedString = NSAttributedString(string: icon.text!, attributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - lineHeight) * 0.5, width: size.width, height: lineHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let image = image {
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: image.imageOrientation)
        } else {
            self.init()
        }
    }

    /**
     This init function adds support for stacked icons. For details check [Stacked Icons](http://fontawesome.io/examples/#stacked)
     
     - Parameter bgIcon: Background icon of the stacked icons
     - Parameter bgTextColor: Color for the background icon
     - Parameter bgBackgroundColor: Background color for the background icon
     - Parameter topIcon: Top icon of the stacked icons
     - Parameter topTextColor: Color for the top icon
     - Parameter bgLarge: Set if the background icon should be bigger
     - Parameter size: CGSize for the UIImage
     
     - Since: 1.0.0
     */
    convenience init(bgIcon: FontType, bgTextColor: UIColor = .black, bgBackgroundColor: UIColor = .clear, topIcon: FontType, topTextColor: UIColor = .black, bgLarge: Bool? = true, size: CGSize? = nil) {

        FontLoader.loadFontIfNeeded(fontType: bgIcon)
        FontLoader.loadFontIfNeeded(fontType: topIcon)

        let bgSize: CGSize!
        let topSize: CGSize!
        let bgRect: CGRect!
        let topRect: CGRect!

        if bgLarge! {
            topSize = size ?? CGSize(width: 30, height: 30)
            bgSize = CGSize(width: 2 * topSize.width, height: 2 * topSize.height)

        } else {

            bgSize = size ?? CGSize(width: 30, height: 30)
            topSize = CGSize(width: 2 * bgSize.width, height: 2 * bgSize.height)
        }

        let bgImage = UIImage.init(icon: bgIcon, size: bgSize, textColor: bgTextColor)
        let topImage = UIImage.init(icon: topIcon, size: topSize, textColor: topTextColor)

        if bgLarge! {
            bgRect = CGRect(x: 0, y: 0, width: bgSize.width, height: bgSize.height)
            topRect = CGRect(x: topSize.width/2, y: topSize.height/2, width: topSize.width, height: topSize.height)
            UIGraphicsBeginImageContextWithOptions(bgImage.size, false, 0.0)

        } else {
            topRect = CGRect(x: 0, y: 0, width: topSize.width, height: topSize.height)
            bgRect = CGRect(x: bgSize.width/2, y: bgSize.height/2, width: bgSize.width, height: bgSize.height)
            UIGraphicsBeginImageContextWithOptions(topImage.size, false, 0.0)

        }

        bgImage.draw(in: bgRect)
        topImage.draw(in: topRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let image = image {
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: image.imageOrientation)
        } else {
            self.init()
        }
    }
}

public extension UIImageView {

    /**
     This function sets the icon to UIImageView
     
     - Parameter icon: The icon for the UIImageView
     - Parameter textColor: Color for the icon
     - Parameter backgroundColor: Background color for the icon
     - Parameter size: CGSize for the UIImage
     
     - Since: 1.0.0
     */
    func setIcon(icon: FontType, textColor: UIColor = .black, backgroundColor: UIColor = .clear, size: CGSize? = nil) {
        self.image = UIImage(icon: icon, size: size ?? frame.size, textColor: textColor, backgroundColor: backgroundColor)
    }
}

public extension UILabel {

    /**
     This function sets the icon to UILabel
     
     - Parameter icon: The icon for the UILabel
     - Parameter iconSize: Size of the icon
     - Parameter textColor: Color for the icon
     - Parameter backgroundColor: Background color for the icon
     
     - Since: 1.0.0
     */
    func setIcon(icon: FontType, iconSize: CGFloat, color: UIColor = .black, bgColor: UIColor = .clear) {
        self.setIcons(
            prefixText: "",
            prefixTextColor: UIColor.clear,
            prefixTextFont: self.font,
            icons: [icon],
            iconsSize: iconSize,
            iconsColor: color,
            bgColor: bgColor,
            postfixText: "",
            postfixTextColor: UIColor.clear,
            postfixTextFont: self.font
        )
    }

    /**
     This function sets the icons to UILabel
     
     - Parameter icons: The icons array for the UILabel
     - Parameter iconSize: Size of all icons
     - Parameter textColor: Color for all icons
     - Parameter backgroundColor: Background color for all icon
     
     - Since: 1.1.0
     */
    fileprivate func setIcons(prefixText: String, prefixTextColor: UIColor, prefixTextFont: UIFont, icons: [FontType], iconsSize: CGFloat, iconsColor: UIColor, bgColor: UIColor, postfixText: String, postfixTextColor: UIColor, postfixTextFont: UIFont) {
        self.text = nil

        backgroundColor = bgColor
        textAlignment = .center
        attributedText = getAttributedString(
            prefixText: prefixText,
            prefixTextColor: prefixTextColor,
            prefixTextFont: prefixTextFont,
            icons: icons,
            iconsSize: iconsSize,
            iconsColor: iconsColor,
            postfixText: postfixText,
            postfixTextColor: postfixTextColor,
            postfixTextFont: postfixTextFont
        )
    }

    func setIcons(prefixText: String? = nil, prefixTextFont: UIFont? = nil, prefixTextColor: UIColor? = nil, icons: [FontType], iconColor: UIColor? = nil, postfixText: String? = nil, postfixTextFont: UIFont? = nil, postfixTextColor: UIColor? = nil, iconSize: CGFloat? = nil, bgColor: UIColor? = nil) {
        self.setIcons(
            prefixText: prefixText ?? "",
            prefixTextColor: prefixTextColor ?? self.textColor,
            prefixTextFont: prefixTextFont ?? self.font,
            icons: icons,
            iconsSize: iconSize ?? self.font.pointSize,
            iconsColor: iconColor ?? self.textColor,
            bgColor: bgColor ?? UIColor.clear,
            postfixText: postfixText ?? "",
            postfixTextColor: postfixTextColor ?? self.textColor,
            postfixTextFont: postfixTextFont ?? self.font
        )
    }

    /**
     This function sets the icon to UILabel with text around it with different colors
     
     - Parameter prefixText: The text before the icon
     - Parameter prefixTextColor: The color for the text before the icon
     - Parameter icon: The icon
     - Parameter iconColor: Color for the icon
     - Parameter postfixText: The text after the icon
     - Parameter postfixTextColor: The color for the text after the icon
     - Parameter size: Size of the text
     - Parameter iconSize: Size of the icon
     
     - Since: 1.0.0
     */
    func setIcon(prefixText: String, prefixTextColor: UIColor = .black, icon: FontType?, iconColor: UIColor = .black, postfixText: String, postfixTextColor: UIColor = .black, size: CGFloat?, iconSize: CGFloat? = nil) {
        let textFont = self.font.withSize(size ?? self.font.pointSize)
        self.setIcons(
            prefixText: prefixText,
            prefixTextColor: prefixTextColor,
            prefixTextFont: textFont,
            icons: icon == nil ? [] : [icon!],
            iconsSize: iconSize ?? self.font.pointSize,
            iconsColor: iconColor,
            bgColor: UIColor.clear,
            postfixText: postfixText,
            postfixTextColor: postfixTextColor,
            postfixTextFont: textFont
        )
    }

    /**
     This function sets the icon to UILabel with text around it with different fonts & colors
     
     - Parameter prefixText: The text before the icon
     - Parameter prefixTextFont: The font for the text before the icon
     - Parameter prefixTextColor: The color for the text before the icon
     - Parameter icon: The icon
     - Parameter iconColor: Color for the icon
     - Parameter postfixText: The text after the icon
     - Parameter postfixTextFont: The font for the text after the icon
     - Parameter postfixTextColor: The color for the text after the icon
     - Parameter iconSize: Size of the icon
     
     - Since: 1.0.0
     */
    func setIcon(prefixText: String, prefixTextFont: UIFont, prefixTextColor: UIColor = .black, icon: FontType?, iconColor: UIColor = .black, postfixText: String, postfixTextFont: UIFont, postfixTextColor: UIColor = .black, iconSize: CGFloat? = nil) {
        self.setIcons(
            prefixText: prefixText,
            prefixTextColor: prefixTextColor,
            prefixTextFont: prefixTextFont,
            icons: icon == nil ? [] : [icon!],
            iconsSize: iconSize ?? self.font.pointSize,
            iconsColor: iconColor,
            bgColor: UIColor.clear,
            postfixText: postfixText,
            postfixTextColor: postfixTextColor,
            postfixTextFont: prefixTextFont
        )

    }
}

public extension UIButton {

    fileprivate func setIcons(prefixText: String, prefixTextColor: UIColor, prefixTextFont: UIFont, icons: [FontType], iconsSize: CGFloat, iconsColor: UIColor, bgColor: UIColor, postfixText: String, postfixTextColor: UIColor, postfixTextFont: UIFont, forState state: UIControl.State) {
        guard let titleLabel = self.titleLabel else { return }
        let attributedText = getAttributedString(
            prefixText: prefixText,
            prefixTextColor: prefixTextColor,
            prefixTextFont: prefixTextFont,
            icons: icons,
            iconsSize: iconsSize,
            iconsColor: iconsColor,
            postfixText: postfixText,
            postfixTextColor: postfixTextColor,
            postfixTextFont: postfixTextFont
        )
        self.setAttributedTitle(attributedText, for: state)
        titleLabel.textAlignment = .center
        self.backgroundColor = bgColor
    }

    func setIcons(prefixText: String? = nil, prefixTextFont: UIFont? = nil, prefixTextColor: UIColor? = nil, icons: [FontType], iconColor: UIColor? = nil, postfixText: String? = nil, postfixTextFont: UIFont? = nil, postfixTextColor: UIColor? = nil, iconSize: CGFloat? = nil, bgColor: UIColor? = nil, forState state: UIControl.State) {
        guard let titleLabel = self.titleLabel else { return }
        self.setIcons(
            prefixText: prefixText ?? "",
            prefixTextColor: prefixTextColor ?? titleLabel.textColor,
            prefixTextFont: prefixTextFont ?? titleLabel.font,
            icons: icons, iconsSize: iconSize ?? titleLabel.font.pointSize,
            iconsColor: iconColor ?? titleLabel.textColor,
            bgColor: bgColor ?? self.backgroundColor ?? UIColor.clear,
            postfixText: postfixText ?? "",
            postfixTextColor: postfixTextColor ?? titleLabel.textColor,
            postfixTextFont: postfixTextFont ?? titleLabel.font,
            forState: state
        )
    }

    /**
     This function sets the icon to UIButton
     
     - Parameter icon: The icon for the UIButton
     - Parameter iconSize: Size of the icon
     - Parameter color: Color for the icon
     - Parameter backgroundColor: Background color for the UIButton
     - Parameter forState: Control state of the UIButton
     
     - Since: 1.1
     */
    func setIcon(icon: FontType, iconSize: CGFloat? = nil, color: UIColor = .black, backgroundColor: UIColor = .clear, forState state: UIControl.State) {
        self.setIcons(icons: [icon], iconColor: color, iconSize: iconSize, bgColor: backgroundColor, forState: state)
    }

    /**
     This function sets the icon to UIButton with text around it with different colors
     
     - Parameter prefixText: The text before the icon
     - Parameter prefixTextColor: The color for the text before the icon
     - Parameter icon: The icon
     - Parameter iconColor: Color for the icon
     - Parameter postfixText: The text after the icon
     - Parameter postfixTextColor: The color for the text after the icon
     - Parameter backgroundColor: Background color for the UIButton
     - Parameter forState: Control state of the UIButton
     - Parameter textSize: Size of the text
     - Parameter iconSize: Size of the icon
     
     - Since: 1.1
     */
    func setIcon(prefixText: String, prefixTextColor: UIColor = .black, icon: FontType, iconColor: UIColor = .black, postfixText: String, postfixTextColor: UIColor = .black, backgroundColor: UIColor = .clear, forState state: UIControl.State, textSize: CGFloat? = nil, iconSize: CGFloat? = nil) {
        guard let titleLabel = self.titleLabel else { return }
        let textFont = titleLabel.font.withSize(textSize ?? titleLabel.font.pointSize)
        self.setIcons(
            prefixText: prefixText,
            prefixTextFont: textFont,
            prefixTextColor: prefixTextColor,
            icons: [icon],
            iconColor: iconColor,
            postfixText: postfixText,
            postfixTextFont: textFont,
            postfixTextColor: postfixTextColor,
            iconSize: iconSize,
            bgColor: backgroundColor,
            forState: state
        )
    }

    /**
     This function sets the icon to UIButton with text around it with different fonts & colors
     
     - Parameter prefixText: The text before the icon
     - Parameter prefixTextFont: The font for the text before the icon
     - Parameter prefixTextColor: The color for the text before the icon
     - Parameter icon: The icon
     - Parameter iconColor: Color for the icon
     - Parameter postfixText: The text after the icon
     - Parameter postfixTextFont: The font for the text after the icon
     - Parameter postfixTextColor: The color for the text after the icon
     - Parameter backgroundColor: Background color for the UIButton
     - Parameter forState: Control state of the UIButton
     - Parameter iconSize: Size of the icon
     
     - Since: 1.1
     */
    func setIcon(prefixText: String, prefixTextFont: UIFont, prefixTextColor: UIColor = .black, icon: FontType?, iconColor: UIColor = .black, postfixText: String, postfixTextFont: UIFont, postfixTextColor: UIColor = .black, backgroundColor: UIColor = .clear, forState state: UIControl.State, iconSize: CGFloat? = nil) {

        self.setIcons(
            prefixText: prefixText,
            prefixTextFont: prefixTextFont,
            prefixTextColor: prefixTextColor,
            icons: icon == nil ? [] : [icon!],
            iconColor: iconColor,
            postfixText: postfixText,
            postfixTextFont: postfixTextFont,
            postfixTextColor: postfixTextColor,
            iconSize: iconSize,
            bgColor: backgroundColor,
            forState: state
        )
    }

    /**
     This function sets the icon to UIButton with title below it, with different colors
     
     - Parameter icon: The icon
     - Parameter iconColor: Color for the icon
     - Parameter title: The title
     - Parameter titleColor: Color for the title
     - Parameter backgroundColor: Background color for the button
     - Parameter borderSize: Border size for the button
     - Parameter borderColor: Border color for the button
     - Parameter forState: Control state of the UIButton
     
     - Since: 1.1
     */
    func setIcon(icon: FontType, iconColor: UIColor = .black, title: String, titleColor: UIColor = .black, backgroundColor: UIColor = .clear, borderSize: CGFloat = 1, borderColor: UIColor = .clear, forState state: UIControl.State) {

        let height = frame.size.height
        let width = frame.size.width
        let gap: CGFloat = 5
        let textHeight: CGFloat = 15

        let size1 = width - (borderSize * 2 + gap * 2)
        let size2 = height - (borderSize * 2 + gap * 3 + textHeight)
        let imageOrigin: CGFloat = borderSize + gap
        let textTop: CGFloat = imageOrigin + size2 + gap
        let textBottom: CGFloat = borderSize + gap
        let imageBottom: CGFloat = textBottom + textHeight + gap

        let image = UIImage.init(icon: icon, size: CGSize(width: size1, height: size2), textColor: iconColor, backgroundColor: backgroundColor)
        imageEdgeInsets = UIEdgeInsets(top: imageOrigin, left: imageOrigin, bottom: imageBottom, right: imageOrigin)
        titleEdgeInsets = UIEdgeInsets(top: textTop, left: -image.size.width, bottom: textBottom, right: 0.0)

        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderSize
        setImage(image, for: state)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.1
        setTitle(title, for: state)
        setTitleColor(titleColor, for: state)
        self.backgroundColor = backgroundColor
    }

    /**
     This function sets the icon to UIButton with title (custom font) below it, with different colors
     
     - Parameter icon: The icon
     - Parameter iconColor: Color for the icon
     - Parameter title: The title
     - Parameter titleColor: Color for the title
     - Parameter font: The font for the title below the icon
     - Parameter backgroundColor: Background color for the button
     - Parameter borderSize: Border size for the button
     - Parameter borderColor: Border color for the button
     - Parameter forState: Control state of the UIButton
     - Since: 1.1
     */
     func setIcon(icon: FontType, iconColor: UIColor = .black, title: String, titleColor: UIColor = .black, font: UIFont, backgroundColor: UIColor = .clear, borderSize: CGFloat = 1, borderColor: UIColor = .clear, forState state: UIControl.State) {

        setIcon(
            icon: icon,
            iconColor: iconColor,
            title: title,
            titleColor: titleColor,
            backgroundColor: backgroundColor,
            borderSize: borderSize,
            borderColor: borderColor,
            forState: state
        )
        titleLabel?.font = font
    }

    /**
     This function sets the icon to UIButton with title below it
     
     - Parameter icon: The icon
     - Parameter title: The title
     - Parameter color: Color for the icon & title
     - Parameter backgroundColor: Background color for the button
     - Parameter borderSize: Border size for the button
     - Parameter borderColor: Border color for the button
     - Parameter forState: Control state of the UIButton
     
     - Since: 1.1
     */
     func setIcon(icon: FontType, title: String, color: UIColor = .black, backgroundColor: UIColor = .clear, borderSize: CGFloat = 1, borderColor: UIColor = .clear, forState state: UIControl.State) {

        setIcon(icon: icon, iconColor: color, title: title, titleColor: color, backgroundColor: backgroundColor, borderSize: borderSize, borderColor: borderColor, forState: state)
    }

    /**
     This function sets the icon to UIButton with title (custom font) below it
     
     - Parameter icon: The icon
     - Parameter title: The title
     - Parameter font: The font for the title below the icon
     - Parameter color: Color for the icon & title
     - Parameter backgroundColor: Background color for the button
     - Parameter borderSize: Border size for the button
     - Parameter borderColor: Border color for the button
     - Parameter forState: Control state of the UIButton
     - Since: 1.1
     */
     func setIcon(icon: FontType, title: String, font: UIFont, color: UIColor = .black, backgroundColor: UIColor = .clear, borderSize: CGFloat = 1, borderColor: UIColor = .clear, forState state: UIControl.State) {

        setIcon(
            icon: icon,
            iconColor: color,
            title: title,
            titleColor: color,
            font: font,
            backgroundColor: backgroundColor,
            borderSize: borderSize,
            borderColor: borderColor,
            forState: state
        )
    }
}

public extension UISegmentedControl {

    /**
     This function sets the icon to UISegmentedControl at particular segment index
     
     - Parameter icon: The icon
     - Parameter color: Color for the icon
     - Parameter iconSize: Size of the icon
     - Parameter forSegmentAtIndex: Segment index for the icon
     
     - Since: 1.0.0
     */
     func setIcon(icon: FontType, color: UIColor = .black, iconSize: CGFloat? = nil, forSegmentAtIndex segment: Int) {
        FontLoader.loadFontIfNeeded(fontType: icon)
        let font = UIFont(name: icon.fontName(), size: iconSize ?? 23)
        assert(font != nil, icon.errorAnnounce())
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: UIControl.State.normal)
        setTitle(icon.text, forSegmentAt: segment)
        tintColor = color
    }
}

public extension UITabBarItem {

    /**
     This function sets the icon to UITabBarItem
     
     - Parameter icon: The icon for the UITabBarItem
     - Parameter size: CGSize for the icon
     - Parameter textColor: Color for the icon when UITabBarItem is not selected
     - Parameter backgroundColor: Background color for the icon when UITabBarItem is not selected
     - Parameter selectedTextColor: Color for the icon when UITabBarItem is selected
     - Parameter selectedBackgroundColor: Background color for the icon when UITabBarItem is selected
     
     - Since: 1.0.0
     */
     func setIcon(icon: FontType, size: CGSize? = nil, textColor: UIColor = .black, backgroundColor: UIColor = .clear, selectedTextColor: UIColor = .black, selectedBackgroundColor: UIColor = .clear) {

        let tabBarItemImageSize = size ?? CGSize(width: 30, height: 30)
        image = UIImage(icon: icon, size: tabBarItemImageSize, textColor: textColor, backgroundColor: backgroundColor).withRenderingMode(.alwaysOriginal)
        selectedImage = UIImage(icon: icon, size: tabBarItemImageSize, textColor: selectedTextColor, backgroundColor: selectedBackgroundColor).withRenderingMode(.alwaysOriginal)
    }

    /**
     This function supports stacked icons for UITabBarItem. For details check [Stacked Icons](http://fontawesome.io/examples/#stacked)
     
     - Parameter bgIcon: Background icon of the stacked icons
     - Parameter bgTextColor: Color for the background icon
     - Parameter selectedBgTextColor: Color for the background icon when UITabBarItem is selected
     - Parameter topIcon: Top icon of the stacked icons
     - Parameter topTextColor: Color for the top icon
     - Parameter selectedTopTextColor: Color for the top icon when UITabBarItem is selected
     - Parameter bgLarge: Set if the background icon should be bigger
     - Parameter size: CGSize for the icon
     
     - Since: 1.0.0
     */
     func setIcon(bgIcon: FontType, bgTextColor: UIColor = .black, selectedBgTextColor: UIColor = .black, topIcon: FontType, topTextColor: UIColor = .black, selectedTopTextColor: UIColor = .black, bgLarge: Bool? = true, size: CGSize? = nil) {

        let tabBarItemImageSize = size ?? CGSize(width: 15, height: 15)
        image = UIImage(
            bgIcon: bgIcon,
            bgTextColor: bgTextColor,
            bgBackgroundColor: .clear,
            topIcon: topIcon,
            topTextColor: topTextColor,
            bgLarge: bgLarge,
            size: tabBarItemImageSize).withRenderingMode(.alwaysOriginal)
        selectedImage = UIImage(
            bgIcon: bgIcon,
            bgTextColor: selectedBgTextColor,
            bgBackgroundColor: .clear,
            topIcon: topIcon,
            topTextColor: selectedTopTextColor,
            bgLarge: bgLarge,
            size: tabBarItemImageSize).withRenderingMode(.alwaysOriginal)
    }
}

public extension UISlider {

    /**
     This function sets the icon to the maximum value of UISlider
     
     - Parameter icon: The icon for the maximum value of UISlider
     - Parameter size: CGSize for the icon
     - Parameter textColor: Color for the icon
     - Parameter backgroundColor: Background color for the icon
     
     - Since: 1.0.0
     */
     func setMaximumValueIcon(icon: FontType, customSize: CGSize? = nil, textColor: UIColor = .black, backgroundColor: UIColor = .clear) {
        maximumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25, height: 25), textColor: textColor, backgroundColor: backgroundColor)
    }

    /**
     This function sets the icon to the minimum value of UISlider
     
     - Parameter icon: The icon for the minimum value of UISlider
     - Parameter size: CGSize for the icon
     - Parameter textColor: Color for the icon
     - Parameter backgroundColor: Background color for the icon
     
     - Since: 1.0.0
     */
     func setMinimumValueIcon(icon: FontType, customSize: CGSize? = nil, textColor: UIColor = .black, backgroundColor: UIColor = .clear) {
        minimumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25, height: 25), textColor: textColor, backgroundColor: backgroundColor)
    }
}

public extension UIBarButtonItem {

    /**
     This function sets the icon for UIBarButtonItem
     
     - Parameter icon: The icon for the for UIBarButtonItem
     - Parameter iconSize: Size for the icon
     - Parameter color: Color for the icon
     
     - Since: 1.0.0
     */
     func setIcon(icon: FontType, iconSize: CGFloat, color: UIColor = .black) {

        FontLoader.loadFontIfNeeded(fontType: icon)
        let font = UIFont(name: icon.fontName(), size: iconSize)
        assert(font != nil, icon.errorAnnounce())
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: UIControl.State.normal)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: UIControl.State.highlighted)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: UIControl.State.disabled)
        setTitleTextAttributes([NSAttributedString.Key.font: font!], for: UIControl.State.focused)
        title = icon.text
        tintColor = color
    }

    /**
     This function sets the icon for UIBarButtonItem using custom view
     
     - Parameter icon: The icon for the for UIBarButtonItem
     - Parameter iconSize: Size for the icon
     - Parameter color: Color for the icon
     - Parameter cgRect: CGRect for the whole icon & text
     - Parameter target: Action target
     - Parameter action: Action for the UIBarButtonItem
     
     - Since: 1.5
     */
     func setIcon(icon: FontType, iconSize: CGFloat, color: UIColor = .black, cgRect: CGRect, target: AnyObject?, action: Selector) {

        let highlightedColor = color.withAlphaComponent(0.4)

        title = nil
        let button = UIButton(frame: cgRect)
        button.setIcon(icon: icon, iconSize: iconSize, color: color, forState: UIControl.State.normal)
        button.setTitleColor(highlightedColor, for: UIControl.State.highlighted)
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)

        customView = button
    }

    /**
     This function sets the icon for UIBarButtonItem with text around it with different colors
     - Parameter prefixText: The text before the icon
     - Parameter prefixTextColor: The color for the text before the icon
     - Parameter icon: The icon
     - Parameter iconColor: Color for the icon
     - Parameter postfixText: The text after the icon
     - Parameter postfixTextColor: The color for the text after the icon
     - Parameter cgRect: CGRect for the whole icon & text
     - Parameter size: Size of the text
     - Parameter iconSize: Size of the icon
     - Parameter target: Action target
     - Parameter action: Action for the UIBarButtonItem
     - Since: 1.5
     */
    func setIcon(prefixText: String, prefixTextColor: UIColor = .black, icon: FontType?, iconColor: UIColor = .black, postfixText: String, postfixTextColor: UIColor = .black, cgRect: CGRect, size: CGFloat?, iconSize: CGFloat? = nil, target: AnyObject?, action: Selector) {

        let prefixTextHighlightedColor = prefixTextColor.withAlphaComponent(0.4)
        let iconHighlightedColor = iconColor.withAlphaComponent(0.4)
        let postfixTextHighlightedColor = postfixTextColor.withAlphaComponent(0.4)

        title = nil
        let button = UIButton(frame: cgRect)
        button.setIcon(
            prefixText: prefixText,
            prefixTextColor: prefixTextColor,
            icon: icon!,
            iconColor: iconColor,
            postfixText: postfixText,
            postfixTextColor: postfixTextColor,
            backgroundColor: .clear,
            forState: UIControl.State.normal,
            textSize: size,
            iconSize: iconSize
        )
        button.setIcon(
            prefixText: prefixText,
            prefixTextColor: prefixTextHighlightedColor,
            icon: icon!, iconColor: iconHighlightedColor,
            postfixText: postfixText,
            postfixTextColor: postfixTextHighlightedColor,
            backgroundColor: .clear,
            forState: UIControl.State.highlighted,
            textSize: size,
            iconSize: iconSize
        )

        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)

        customView = button
    }

    /**
     This function sets the icon for UIBarButtonItem with text around it with different colors
     
     - Parameter prefixText: The text before the icon
     - Parameter prefixTextColor: The color for the text before the icon
     - Parameter prefixTextColor: The color for the text before the icon
     - Parameter icon: The icon
     - Parameter iconColor: Color for the icon
     - Parameter postfixText: The text after the icon
     - Parameter postfixTextColor: The color for the text after the icon
     - Parameter postfixTextColor: The color for the text after the icon
     - Parameter cgRect: CGRect for the whole icon & text
     - Parameter size: Size of the text
     - Parameter iconSize: Size of the icon
     - Parameter target: Action target
     - Parameter action: Action for the UIBarButtonItem
     
     - Since: 1.5
     */
    func setIcon(prefixText: String, prefixTextFont: UIFont, prefixTextColor: UIColor = .black, icon: FontType?, iconColor: UIColor = .black, postfixText: String, postfixTextFont: UIFont, postfixTextColor: UIColor = .black, cgRect: CGRect, iconSize: CGFloat? = nil, target: AnyObject?, action: Selector) {

        let prefixTextHighlightedColor = prefixTextColor.withAlphaComponent(0.4)
        let iconHighlightedColor = iconColor.withAlphaComponent(0.4)
        let postfixTextHighlightedColor = postfixTextColor.withAlphaComponent(0.4)

        title = nil
        let button = UIButton(frame: cgRect)
        button.setIcon(
            prefixText: prefixText,
            prefixTextFont: prefixTextFont,
            prefixTextColor: prefixTextColor,
            icon: icon,
            iconColor: iconColor,
            postfixText: postfixText,
            postfixTextFont: postfixTextFont,
            postfixTextColor: postfixTextColor,
            backgroundColor: .clear,
            forState: UIControl.State.normal,
            iconSize: iconSize
        )
        button.setIcon(
            prefixText: prefixText,
            prefixTextFont: prefixTextFont,
            prefixTextColor: prefixTextHighlightedColor,
            icon: icon,
            iconColor: iconHighlightedColor,
            postfixText: postfixText,
            postfixTextFont: postfixTextFont,
            postfixTextColor: postfixTextHighlightedColor,
            backgroundColor: .clear,
            forState: UIControl.State.highlighted,
            iconSize: iconSize
        )
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)

        customView = button
    }
}

public extension UIStepper {

    /**
     This function sets the increment icon for UIStepper
     
     - Parameter icon: The icon for the for UIStepper
     - Parameter forState: Control state of the increment icon of the UIStepper
     
     - Since: 1.0.0
     */
    func setIncrementIcon(icon: FontType?, forState state: UIControl.State) {

        let backgroundSize = CGSize(width: 20, height: 20)
        let image = UIImage(icon: icon!, size: backgroundSize)
        setIncrementImage(image, for: state)
    }

    /**
     This function sets the decrement icon for UIStepper
     
     - Parameter icon: The icon for the for UIStepper
     - Parameter forState: Control state of the decrement icon of the UIStepper
     
     - Since: 1.0.0
     */
    func setDecrementIcon(icon: FontType?, forState state: UIControl.State) {

        let backgroundSize = CGSize(width: 20, height: 20)
        let image = UIImage(icon: icon!, size: backgroundSize)
        setDecrementImage(image, for: state)
    }
}

public extension UITextField {

    /**
     This function sets the icon for the right view of the UITextField
     
     - Parameter icon: The icon for the right view of the UITextField
     - Parameter rightViewMode: UITextFieldViewMode for the right view of the UITextField
     - Parameter textColor: Color for the icon
     - Parameter backgroundColor: Background color for the icon
     - Parameter size: CGSize for the icon
     
     - Since: 1.0.0
     */
     func setRightViewIcon(icon: FontType, rightViewMode: UITextField.ViewMode = .always, textColor: UIColor = .black, backgroundColor: UIColor = .clear, size: CGSize? = nil) {
        FontLoader.loadFontIfNeeded(fontType: icon)

        let image = UIImage(icon: icon, size: size ?? CGSize(width: 30, height: 30), textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView.init(image: image)

        self.rightView = imageView
        self.rightViewMode = rightViewMode
    }

    /**
     This function sets the icon for the left view of the UITextField
     
     - Parameter icon: The icon for the left view of the UITextField
     - Parameter leftViewMode: UITextFieldViewMode for the left view of the UITextField
     - Parameter textColor: Color for the icon
     - Parameter backgroundColor: Background color for the icon
     - Parameter size: CGSize for the icon
     
     - Since: 1.0.0
     */
    func setLeftViewIcon(icon: FontType, leftViewMode: UITextField.ViewMode = .always, textColor: UIColor = .black, backgroundColor: UIColor = .clear, size: CGSize? = nil) {
        FontLoader.loadFontIfNeeded(fontType: icon)

        let image = UIImage(icon: icon, size: size ?? CGSize(width: 30, height: 30), textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView.init(image: image)

        self.leftView = imageView
        self.leftViewMode = leftViewMode
    }
}

public extension UIViewController {

    /**
     This function sets the icon for the title of navigation bar
     
     - Parameter icon: The icon for the title of navigation bar
     - Parameter iconSize: Size of the icon
     - Parameter textColor: Color for the icon
     
     - Since: 1.0.0
     */
    func setTitleIcon(icon: FontType, iconSize: CGFloat? = nil, color: UIColor = .black) {
        let size = iconSize ?? 23
        FontLoader.loadFontIfNeeded(fontType: icon)
        let font = UIFont(name: icon.fontName(), size: size)
        assert(font != nil, icon.errorAnnounce())
        let titleAttributes = [NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: color]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = icon.text
    }
}

private class FontLoader {
    /**
     This utility function helps loading the font if not loaded already
     - Parameter fontType: The type of the font
     */
    static func loadFontIfNeeded(fontType: FontType) {
        let fileName = fontType.fileName()
        let fontName = fontType.fontName()

        if !loadedFontsTracker[fontName]! {
            let bundle = Bundle(for: FontLoader.self)
            var fontURL: URL!
            let identifier = bundle.bundleIdentifier
            if (identifier?.hasPrefix("org.cocoapods"))! {
                fontURL = bundle.url(forResource: fileName, withExtension: "ttf", subdirectory: "DizzyIcons.bundle")
            } else {
                fontURL = bundle.url(forResource: fileName, withExtension: "ttf")!
            }
            do {
                let data = try Data(contentsOf: fontURL)

                let provider = CGDataProvider(data: data as CFData)
                let font = CGFont(provider!)!

                var error: Unmanaged<CFError>?
                if !CTFontManagerRegisterGraphicsFont(font, &error) {
                    let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
                    // swiftlint:disable force_cast
                    let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
                    // swiftlint:enable force_cast
                    NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
                } else {
                    loadedFontsTracker[fontName] = true
                }
            } catch {
                print("Error : \(error)")
            }
        }
    }
}

private var loadedFontsTracker: [String: Bool] = ["FontAwesome5Free-Solid": false, "FontAwesome5Free-Regular": false, "FontAwesome5Brands-Regular": false, "icomoon": false]

protocol FontProtocol {
    func familyName() -> String
    func fileName() -> String
    func fontName() -> String
}

/**
 FontType Enum
 ````
 case fontAwesome()
 ````
 */

public enum FontType: FontProtocol {

    case fontAwesomeSolid(Solid)
    case fontAwesomeRegular(Regular)
    case fontAwesomeBrands(Brands)
    case fontMessage(Message)

    func fontName() -> String {
        var fontName: String
        switch self {
        case .fontAwesomeSolid:
            fontName = "FontAwesome5Free-Solid"
        case .fontAwesomeRegular:
            fontName = "FontAwesome5Free-Regular"
        case .fontAwesomeBrands:
            fontName = "FontAwesome5Brands-Regular"
        case .fontMessage:
            fontName = "icomoon"
        }
        return fontName
    }

    /**
     This function returns the file name from Source folder using font type
     */
    func fileName() -> String {
        var fileName: String
        switch self {
        case .fontAwesomeSolid:
            fileName = "fa-solid-900"
        case .fontAwesomeRegular:
            fileName = "fa-regular-400"
        case .fontAwesomeBrands:
            fileName = "fa-brands-400"
        case .fontMessage:
            fileName = "icon-message"
        }
        return fileName
    }

    /**
     This function returns the font family name using font type
     */
    func familyName() -> String {
        var familyName: String
        switch self {
        case .fontAwesomeSolid:
            familyName = "Font Awesome 5 Free"
        case .fontAwesomeRegular:
            familyName = "Font Awesome 5 Free"
        case .fontAwesomeBrands:
            familyName = "Font Awesome 5 Brands"
        case .fontMessage:
            familyName = "icomoon"
        }
        return familyName
    }

    /**
     This function returns the error for a font type
     */
    func errorAnnounce() -> String {
        let message = " FONT - not associated with Info.plist when manual installation was performed"
        let fontName = self.fontName().uppercased()
        let errorAnnounce = fontName.appending(message)
        return errorAnnounce
    }

    /**
     This function returns the text for the icon
     */
    public var text: String? {
        var text: String

        switch self {
        case let .fontAwesomeSolid(icon):
            text = icon.text!
        case let .fontAwesomeBrands(icon):
            text = icon.text!
        case let .fontAwesomeRegular(icon):
            text = icon.text!
        case let .fontMessage(icon):
            text = icon.text!
        }
        return text
    }
}

private func getAttributedString(prefixText: String, prefixTextColor: UIColor, prefixTextFont: UIFont, icons: [FontType], iconsSize: CGFloat, iconsColor: UIColor, postfixText: String, postfixTextColor: UIColor, postfixTextFont: UIFont) -> NSAttributedString {
    icons.forEach { FontLoader.loadFontIfNeeded(fontType: $0) }
    let iconFonts = icons.map { UIFont(name: $0.fontName(), size: iconsSize) }

    for (index, element) in iconFonts.enumerated() {
        assert(element != nil, icons[index].errorAnnounce())
    }

    let iconsString = icons.reduce("") { $0 + ($1.text ?? "") }
    let resultAttrString = NSMutableAttributedString(string: "\(prefixText)\(iconsString)\(postfixText)")

    //add prefix text attribute
    resultAttrString.addAttributes([
        NSAttributedString.Key.font: prefixTextFont,
        NSAttributedString.Key.foregroundColor: prefixTextColor
        ], range: NSRange(location: 0, length: prefixText.count))

    //add icons attribute
    resultAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: iconsColor, range: NSRange(location: prefixText.count, length: iconsString.count))
    for index in icons.indices {
        resultAttrString.addAttribute(NSAttributedString.Key.font, value: iconFonts[index]!, range: NSRange(location: prefixText.count + index, length: 1))
    }

    //add postfix text attribute
    if !postfixText.isEmpty {
        resultAttrString.addAttributes([
            NSAttributedString.Key.font: postfixTextFont,
            NSAttributedString.Key.foregroundColor: postfixTextColor
            ], range: NSRange(location: prefixText.count + iconsString.count, length: postfixText.count))
    }

    return resultAttrString
}

public enum Solid: Int {

    public static var count: Int {
        return solidFonts.count
    }

    public var text: String? {
        return solidFonts[rawValue]
    }

    case cog, shareSquare, ellipsisH, chevronRight, yenSign, mapMarkerAlt, camera, clipboardList, edit, arrowRight, heartBroken, ellipsisV, circle, user, mapMarker,
    building, bookmark, check, infoCircle, times, filter
}

private let solidFonts = [
    "\u{f013}", "\u{f14d}", "\u{f141}", "\u{f054}", "\u{f157}", "\u{f3c5}",
    "\u{f030}", "\u{f46d}", "\u{f044}", "\u{f061}", "\u{f7a9}", "\u{f142}",
    "\u{f111}", "\u{f007}", "\u{f3c5}", "\u{f1ad}", "\u{f02e}", "\u{f00c}",
    "\u{f05a}", "\u{f00d}", "\u{f0b0}"
]

public enum Regular: Int {

    public static var count: Int {
        return regularFonts.count
    }

    public var text: String? {
        return regularFonts[rawValue]
    }

    case clock, frown, bookmark, shareSquare
}

private let regularFonts = ["\u{f017}", "\u{f119}", "\u{f02e}", "\u{f14d}"]

public enum Brands: Int {

    public static var count: Int {
        return brandsFonts.count
    }

    public var text: String? {
        return brandsFonts[rawValue]
    }

    case facebookSquare, linkedin
}

private let brandsFonts = ["\u{f082}", "\u{f08c}"]

public enum Message: Int {

    public static var count: Int {
        return messageIcon.count
    }

    public var text: String? {
        return messageIcon[rawValue]
    }

    case message
}
private let messageIcon = ["\u{e900}"]

//swiftlint:enable file_length
