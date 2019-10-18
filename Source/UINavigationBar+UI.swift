//
//  UINavigationBar+UI.swift
//  GGUI
//
//  Created by John on 2019/3/11.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UINavigationBar {
    func setup(navigationAppearance: NavigationAppearance) {
        barTintColor = navigationAppearance.barTintColor
        tintColor = navigationAppearance.tintColor
        setTitle(color: navigationAppearance.titleColor, font: navigationAppearance.titleFont)
        setBackground(alpha: navigationAppearance.backgroundAlpha)
        setupShadowLine(remove: !navigationAppearance.showShadowLine)
    }

    /// 改变背景 alpha
    var barBackgroundView: UIView? {
        return self.subviews
            .filter { NSStringFromClass(type(of: $0)) == "_UIBarBackground" }
            .first
    }

    func setBackground(alpha: CGFloat) {
        print("😄 alpha: \(alpha)")
        if #available(iOS 13, *) {
            if alpha == 0 {
                standardAppearance.configureWithTransparentBackground()
            } else if alpha == 1 {
                standardAppearance.configureWithOpaqueBackground()
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

    /// 设置标题颜色，字体
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - font: 字体
    func setTitle(color: UIColor, font: UIFont) {
        titleTextAttributes = [.font: font, .foregroundColor: color]
    }

    /// 设置分割线
    /// - Parameter remove: 是否移除
    func setupShadowLine(remove: Bool) {
        if remove {
            if #available(iOS 13, *) {
                standardAppearance.shadowColor = .clear
            } else {
                /// ios10 直接 shadowImage = UIImage() 无用
                if SYSTEM_VERSION_LESS_THAN(version: "11") {
                    if let shadow = findShadowImage(under: self) {
                        shadow.isHidden = true
                    }
                } else {
                    shadowImage = UIImage()
                }
            }
        } else {
            if #available(iOS 13, *) {
                standardAppearance.shadowColor = GGUI.LineView.color
            } else {
                if SYSTEM_VERSION_LESS_THAN(version: "11") {
                    if let shadow = findShadowImage(under: self) {
                        shadow.isHidden = false
                    }
                } else {
                    shadowImage = UIImage(color: GGUI.LineView.color, size: CGSize(width: 1, height: 0.5))
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
}
