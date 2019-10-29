//
//  NavigationAppearance.swift
//  EasyNavigationBar
//
//  Created by John on 2019/10/29.
//  Copyright © 2019 John. All rights reserved.
//

import UIKit

public struct NavigationBarConfig {
    /// 返回按钮的图标
    public static var debugMode: Bool = false
    /// 返回按钮的图标
    public static var backIconImage: UIImage?
    /// 样式（透明度，颜色，分割线等）
    public static var appearance: NavigationAppearance = NavigationAppearance()
}

public struct NavigationAppearance {
    /// 是否隐藏导航栏，默认不隐藏，如果 true，下面的所有属性都不起作用
    public var isNavigationBarHidden = false
    /// 是否显示底部的横线，默认显示
    public var isShowShadowLine = true
    /// 底部的横线颜色
    public var shadowColor: UIColor = .lightGray
    /// 背景透明度，可实现渐变效果，切换效果
    public var backgroundAlpha: CGFloat = 1.0
    /// 背景颜色，不同的背景颜色之间会有渐变的切换效果（todo）, 默认为 UINavigationBar.appearance().barTintColor （即 nil）, 此时的效果为 translucent（毛玻璃背景）
    public var barTintColor: UIColor? = UINavigationBar.appearance().barTintColor
    /// 按钮控件的颜色，不同的颜色之间会有渐变的切换效果, 默认为 UINavigationBar.appearance().tintColor
    public var tintColor: UIColor = .black
    /// 标题 TextAttributes
    public var titleTextAttributes: [NSAttributedString.Key: Any]? = UINavigationBar.appearance().titleTextAttributes

    public init() {}

    public init(isNavigationBarHidden: Bool = false,
                isShowShadowLine: Bool = true,
                shadowColor: UIColor = .lightGray,
                backgroundAlpha: CGFloat = 1.0,
                barTintColor: UIColor? = UINavigationBar.appearance().barTintColor,
                tintColor: UIColor = .black,
                titleTextAttributes: [NSAttributedString.Key: Any]? = UINavigationBar.appearance().titleTextAttributes) {
        self.isNavigationBarHidden = isNavigationBarHidden
        self.isShowShadowLine = isShowShadowLine
        self.shadowColor = shadowColor
        self.backgroundAlpha = backgroundAlpha
        self.barTintColor = barTintColor
        self.tintColor = tintColor
        self.titleTextAttributes = titleTextAttributes
    }
}
