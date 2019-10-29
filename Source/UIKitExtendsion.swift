//
//  UIKitExtendsion.swift
//  EasyNavigationBar
//
//  Created by John on 2019/10/29.
//  Copyright © 2019 John. All rights reserved.
//

import UIKit

public extension UIView {
    func recursiveFindSubview(of name: String) -> UIView? {
        for view in subviews {
            if view.isKind(of: NSClassFromString(name)!) {
                return view
            }
        }
        for view in subviews {
            if let tempView = view.recursiveFindSubview(of: name) {
                return tempView
            }
        }
        return nil
    }
}

public extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }

        self.init(cgImage: aCgImage)
    }

    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
}

public extension UIFont {
    var fontWeight: UIFont.Weight {
        let fontAttributeKey = UIFontDescriptor.AttributeName.init(rawValue: "NSCTFontUIUsageAttribute")
        if let fontWeight = self.fontDescriptor.fontAttributes[fontAttributeKey] as? String {
            switch fontWeight {
            case "CTFontBoldUsage":
                return UIFont.Weight.bold
            case "CTFontBlackUsage":
                return UIFont.Weight.black
            case "CTFontHeavyUsage":
                return UIFont.Weight.heavy
            case "CTFontUltraLightUsage":
                return UIFont.Weight.ultraLight
            case "CTFontThinUsage":
                return UIFont.Weight.thin
            case "CTFontLightUsage":
                return UIFont.Weight.light
            case "CTFontMediumUsage":
                return UIFont.Weight.medium
            case "CTFontDemiUsage":
                return UIFont.Weight.semibold
            case "CTFontRegularUsage":
                return UIFont.Weight.regular
            default:
                return UIFont.Weight.regular
            }
        }
        return UIFont.Weight.regular
    }
}

public extension UIColor {
    /// Calculate the middle Color with translation percent
    static func averageColor(from fromColor: UIColor, to toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)

        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)

        let nowRed = fromRed + (toRed - fromRed) * percent
        let nowGreen = fromGreen + (toGreen - fromGreen) * percent
        let nowBlue = fromBlue + (toBlue - fromBlue) * percent
        let nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent

        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
}
