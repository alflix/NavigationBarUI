//
//  UINavigationBar+UI.swift
//  EasyNavigationBar
//
//  Created by John on 2019/3/11.
//  Copyright © 2019 John. All rights reserved.
//

import UIKit

public extension UINavigationBar {
    fileprivate struct AssociatedKey {
        static var appearanceKey: String = "com.ganguo.appearanceKey"
    }

    /// 控制器上的导航栏样式，若不设置，以其 navigationController 的为准
    public var appearance: NavigationAppearance {
        get {
            if let value = associatedObject(forKey: &AssociatedKey.appearanceKey) as? NavigationAppearance {
                return value
            }
            return Config.appearance
        }
        set {
            if newValue.isNavigationBarHidden {
                associate(retainObject: newValue, forKey: &AssociatedKey.appearanceKey)
                return
            }
            if newValue == appearance { return }
            if !(isTranslucent ?? true) && newValue.backgroundAlpha <= 1 {
                DPrint("⚠️ warning: backgroundAlpha would not available when isTranslucent is false")
            }
            setupAppearance(newValue)
            associate(retainObject: newValue, forKey: &AssociatedKey.appearanceKey)
        }
    }

    fileprivate func setupAppearance(_ appearance: NavigationAppearance) {
        if appearance.isNavigationBarHidden { return }
        if appearance.backgroundAlpha > 0 {
            setupShadowLineStatus(isShow: appearance.isShowShadowLine, color: appearance.shadowColor)
        } else {
            setupShadowLineStatus(isShow: false, color: appearance.shadowColor)
        }
        if appearance.barTintColor != self.appearance.barTintColor {
            setupBarTintColor(appearance.barTintColor)
        }
        if appearance.backgroundAlpha != self.appearance.backgroundAlpha {
            setupBackgroundAlpha(appearance.backgroundAlpha)
        }
        if appearance.titleTextAttributes != self.appearance.titleTextAttributes {
            setupTitleTextAttributes(appearance.titleTextAttributes)
        }
        if appearance.barButtonItemTitleTextAttributes != self.appearance.barButtonItemTitleTextAttributes {
            setupBarButtonItemTitleTextAttributes(appearance.barButtonItemTitleTextAttributes)
        }
        if appearance.tintColor != self.appearance.tintColor {
            tintColor = appearance.tintColor
        }
    }

    func updateAppearance(from appearance: NavigationAppearance, to toAppearance: NavigationAppearance, progress: CGFloat) {
        // todo: barTintColor, 下面的逻辑在 updateInteractiveTransition 无法实现，需要找其他方案
        // todo: titleTextAttributes
        let tintColor = UIColor.averageColor(from: appearance.tintColor, to: toAppearance.tintColor, percent: progress)
        let alpha = appearance.backgroundAlpha + (toAppearance.backgroundAlpha - appearance.backgroundAlpha) * progress

        var toAppearance = toAppearance
        toAppearance.tintColor = tintColor
        toAppearance.backgroundAlpha = alpha
        self.appearance = toAppearance
    }

    func setupBackgroundAlpha(_ alpha: CGFloat) {
        DPrint("change alpha: \(alpha)")
        if #available(iOS 13, *) {
            if alpha == 0 {
                standardAppearance.configureWithTransparentBackground()
            } else {
                standardAppearance.backgroundColor = barTintColor?.withAlphaComponent(alpha)
            }
            return
        }
        guard barBackgroundView != nil else { return }
        /// MARK: 尝试过很多方法，isTranslucent == false 无论怎么改都没有效果
        guard isTranslucent else { return }
        if let backgroundEffectView = recursiveFindSubview(of: "UIVisualEffectView"),
            backgroundImage(for: .default) == nil {
            backgroundEffectView.alpha = alpha
            return
        }
    }

    func setupBarTintColor(_ color: UIColor?) {
        DPrint("change barTintColor: \(String(describing: color))")
        if #available(iOS 13, *) {
            barTintColor = color
            standardAppearance.backgroundColor = color
        } else {
            barTintColor = color
        }
    }

    func setupTitleTextAttributes(_ titleTextAttributes: TextAttributesItem) {
        if #available(iOS 13, *) {
            standardAppearance.titleTextAttributes = titleTextAttributes.attributed
        } else {
            self.titleTextAttributes = titleTextAttributes.attributed
        }
    }

    func setupBarButtonItemTitleTextAttributes(_ titleTextAttributes: BarButtonItemTitleTextAttributes) {
        if #available(iOS 13, *) {
            standardAppearance.buttonAppearance.normal.titleTextAttributes = titleTextAttributes.normal.attributed
            standardAppearance.buttonAppearance.highlighted.titleTextAttributes = titleTextAttributes.highlighted.attributed
            standardAppearance.buttonAppearance.disabled.titleTextAttributes = titleTextAttributes.disabled.attributed
        } else {
            UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes.normal.attributed, for: .normal)
            UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes.highlighted.attributed, for: .highlighted)
            UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes.disabled.attributed, for: .disabled)
        }
    }

    func setupShadowLineStatus(isShow: Bool, color: UIColor) {
        if isShow {
            if #available(iOS 13, *) {
                standardAppearance.shadowColor = color
            } else {
                if #available(iOS 11, *) {
                    if let shadow = findShadowImage(under: self) {
                        shadow.isHidden = false
                    }
                } else {
                    shadowImage = UIImage(color: color, size: CGSize(width: 1, height: 0.5))
                }
            }

        } else {
            if #available(iOS 13, *) {
                standardAppearance.shadowColor = .clear
            } else {
                /// ios10 直接 shadowImage = UIImage() 无用
                if #available(iOS 11, *) {
                    if let shadow = findShadowImage(under: self) {
                        shadow.isHidden = true
                    }
                } else {
                    shadowImage = UIImage()
                }
            }
        }
    }

    private func findShadowImage(under view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1 {
            return (view as! UIImageView)
        }
        for subview in view.subviews {
            if let imageView = findShadowImage(under: subview) {
                return imageView
            }
        }
        return nil
    }

    /// 改变背景 alpha
    private var barBackgroundView: UIView? {
        return self.subviews
            .filter { NSStringFromClass(type(of: $0)) == "_UIBarBackground" }
            .first
    }
}
