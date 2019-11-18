//
//  UIViewController+Navigation.swift
//  EasyNavigationBar
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 John. All rights reserved.
//

import UIKit

extension UIViewController {
    fileprivate struct AssociatedKey {
        static var appearanceKey: String = "com.ganguo.appearanceKey"
    }

    /// 控制器上的导航栏样式，若不设置，以其 navigationController 的为准
    open var navigationAppearance: NavigationAppearance {
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
            if let viewController = self as? UINavigationController {
                viewController.navigationBar.appearance = newValue
            } else if let navigationController = navigationController {
                navigationController.navigationBar.appearance = newValue
            }
            associate(retainObject: newValue, forKey: &AssociatedKey.appearanceKey)
        }
    }
}
