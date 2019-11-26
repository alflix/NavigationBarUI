//
//  UIViewController+Swizzle.swift
//  EasyNavigationBar
//
//  Created by John on 2019/8/16.
//  Copyright © 2019年 EasyNavigationBar. All rights reserved.
//

import UIKit

public typealias ViewWillAppearBlock = (_ viewController: UIViewController, _ animated: Bool) -> Void
public typealias ViewDidAppearBlock = (_ viewController: UIViewController) -> Void

public extension UIViewController {
    static func swizzleViewWillAppear() {
        DispatchQueue.once {
            swizzling(
                UIViewController.self,
                #selector(UIViewController.viewWillAppear(_:)),
                #selector(UIViewController.swizzle_viewWillAppear(_:)))
            swizzling(
                UIViewController.self,
                #selector(UIViewController.viewDidAppear(_:)),
                #selector(UIViewController.swizzle_viewDidAppear(_:)))
            swizzling(
                UIViewController.self,
                #selector(UIViewController.addChild(_:)),
                #selector(UIViewController.swizzle_addChild(_:)))
        }
    }

    fileprivate struct AssociatedKey {
        static var viewWillAppearHandlerWrapper: String = "com.EasyNavigationBar.viewWillAppear"
        static var viewDidAppearHandlerWrapper: String = "com.EasyNavigationBar.viewDidAppear"
        static var viewIsInteractiveTransition: String = "com.EasyNavigationBar.viewIsInteractiveTransition"
    }

    var viewWillAppearHandler: ViewWillAppearBlock? {
        get {
            guard let block = associatedObject(forKey: &AssociatedKey.viewWillAppearHandlerWrapper) as? ViewWillAppearBlock else {
                return nil
            }
            return block
        }
        set {
            associate(copyObject: newValue, forKey: &AssociatedKey.viewWillAppearHandlerWrapper)
        }
    }

    var viewDidAppearHandler: ViewDidAppearBlock? {
        get {
            guard let block = associatedObject(forKey: &AssociatedKey.viewDidAppearHandlerWrapper) as? ViewDidAppearBlock else {
                return nil
            }
            return block
        }
        set {
            associate(copyObject: newValue, forKey: &AssociatedKey.viewDidAppearHandlerWrapper)
        }
    }

    var viewIsInteractiveTransition: Bool {
        get {
            if let boolen = associatedObject(forKey: &AssociatedKey.viewIsInteractiveTransition) as? Bool {
                return boolen
            }
            return false
        }
        set {
            associate(copyObject: newValue, forKey: &AssociatedKey.viewIsInteractiveTransition)
        }
    }

    @objc private func swizzle_viewWillAppear(_ animated: Bool) {
        swizzle_viewWillAppear(animated)
        if let viewWillAppearHandler = viewWillAppearHandler {
            viewWillAppearHandler(self, animated)
        }
    }

    @objc private func swizzle_viewDidAppear(_ animated: Bool) {
        swizzle_viewDidAppear(animated)
        if let viewDidAppearHandler = viewDidAppearHandler {
            viewDidAppearHandler(self)
        }
    }

    @objc private func swizzle_addChild(_ childController: UIViewController) {
        swizzle_addChild(childController)
        let block: ViewWillAppearBlock = { [weak self] (viewController, animated) in
            guard let self = self, let parent = viewController.parent else { return }
            self.navigationController?.setNavigationBarHidden(parent.navigationAppearance.isNavigationBarHidden, animated: animated)
        }
        childController.viewWillAppearHandler = block
    }
}
