//
//  UINavigationController+Swizzle.swift
//  EasyNavigationBar
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 John. All rights reserved.
//

import UIKit

public extension UINavigationController {
    static func swizzle() {
        DispatchQueue.once {
            swizzling(
                UINavigationController.self,
                NSSelectorFromString("_updateInteractiveTransition:"),
                #selector(UINavigationController.swizzle_updateInteractiveTransition(_:)))
            swizzling(
                UINavigationController.self,
                #selector(UINavigationController.pushViewController(_:animated:)),
                #selector(UINavigationController.swizzle_pushViewController(_:animated:)))
            swizzling(
                UINavigationController.self,
                #selector(UINavigationController.popToViewController(_:animated:)),
                #selector(UINavigationController.swizzle_popToViewController(_:animated:)))
            swizzling(
                UINavigationController.self,
                #selector(UINavigationController.popToRootViewController(animated:)),
                #selector(UINavigationController.swizzle_popToRootViewControllerAnimated(_:)))
        }
    }

    @objc private func swizzle_updateInteractiveTransition(_ percentComplete: CGFloat) {
        guard let topVC = topViewController,
            let coordinator = topVC.transitionCoordinator,
            !topVC.navigationAppearance.isNavigationBarHidden else {
                swizzle_updateInteractiveTransition(percentComplete)
                return
        }
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        toVC?.viewIsInteractiveTransition = true
        updateNavigationBar(from: fromVC, to: toVC, progress: percentComplete, setupShowLine: percentComplete > 0.5)
        swizzle_updateInteractiveTransition(percentComplete)
    }

    @objc private func swizzle_pushViewController(_ viewController: UIViewController, animated: Bool) {
        let block: ViewWillAppearBlock = { [weak self] (viewController, animated) in
            guard let strongSelf = self else { return }
            strongSelf.setNavigationBarHidden(viewController.navigationAppearance.isNavigationBarHidden, animated: animated)
            // 由于 iOS 13 不响应 UINavigationBarDelegate
            if #available(iOS 13, *) {
                DispatchQueue.delay(0.1) {
                    if viewController.viewIsInteractiveTransition {
                        viewController.viewIsInteractiveTransition = false
                        return
                    }
                    strongSelf.navigationBar.setupAppearance(viewController.navigationAppearance)
                }
                if let topVC = self?.topViewController, let coordinator = topVC.transitionCoordinator,
                    coordinator.initiallyInteractive {
                    coordinator.notifyWhenInteractionChanges({ (context) in
                        self?.dealInteractionChanges(context)
                    })
                }
            }
        }
        viewController.viewWillAppearHandler = block
        if let disappearingViewController = viewControllers.last, disappearingViewController.viewWillAppearHandler == nil {
            disappearingViewController.viewWillAppearHandler = block
        }
        pushTransaction {
            swizzle_pushViewController(viewController, animated: animated)
        }
    }

    @objc private func swizzle_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        return popsTransaction {
            swizzle_popToViewController(viewController, animated: animated)
        }
    }

    @objc private func swizzle_popViewController(animated: Bool) -> UIViewController? {
        let poppedViewController = swizzle_popViewController(animated: animated)
        if viewControllers.count > 0 {
            let topViewController = viewControllers[viewControllers.count - 1]
            return popToViewController(topViewController, animated: animated)?.first
        }
        return poppedViewController
    }

    @objc private func swizzle_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
        return popsTransaction {
            swizzle_popToRootViewControllerAnimated(animated)
        }
    }

    @objc private func pushTransaction(block: () -> Void) {
        var displayLink: CADisplayLink? = CADisplayLink(target: self, selector: #selector(animationDisplay))
        // UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响
        displayLink?.add(to: .main, forMode: .common)
        CATransaction.setCompletionBlock {
            displayLink?.invalidate()
            displayLink = nil
            AnimationProperties.displayCount = 0
        }
        CATransaction.setAnimationDuration(AnimationProperties.duration)
        CATransaction.begin()
        block()
        CATransaction.commit()
    }

    @objc private func popsTransaction(block: () -> [UIViewController]?) -> [UIViewController]? {
        var displayLink: CADisplayLink? = CADisplayLink(target: self, selector: #selector(animationDisplay))
        displayLink?.add(to: .main, forMode: .common)
        CATransaction.setCompletionBlock {
            displayLink?.invalidate()
            displayLink = nil
            AnimationProperties.displayCount = 0
        }
        CATransaction.setAnimationDuration(AnimationProperties.duration)
        CATransaction.begin()
        let viewControllers = block()
        CATransaction.commit()
        return viewControllers
    }

    private struct AnimationProperties {
        static let duration = 0.13
        static var displayCount = 0
        static var progress: CGFloat {
            let all: CGFloat = CGFloat(60.0 * duration)
            let current = min(all, CGFloat(displayCount))
            return current / all
        }
    }
}

// MARK: - UI Update
extension UINavigationController {
    @objc private func animationDisplay() {
        guard let topVC = topViewController, let coordinator = topVC.transitionCoordinator else { return }
        AnimationProperties.displayCount += 1
        let progress = AnimationProperties.progress
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(from: fromVC, to: toVC, progress: progress, setupShowLine: true)
    }

    private func updateNavigationBar(from fromVC: UIViewController?,
                                     to toVC: UIViewController?,
                                     progress: CGFloat,
                                     setupShowLine: Bool = false) {
        guard let fromVC = fromVC, let toVC = toVC else { return }
        navigationBar.updateAppearance(from: fromVC.navigationAppearance, to: toVC.navigationAppearance, progress: progress)
    }

    /// 处理手势进行到一半又停止的情况
    private func dealInteractionChanges(_ context: UIViewControllerTransitionCoordinatorContext) {
        let animations: (UITransitionContextViewControllerKey) -> Void = {
            guard let viewController = context.viewController(forKey: $0) else { return }
            self.navigationBar.setupAppearance(viewController.navigationAppearance)
        }

        // 完成返回手势的取消事件
        if context.isCancelled {
            let cancelDuration: TimeInterval = context.transitionDuration * Double(context.percentComplete)
            UIView.animate(withDuration: cancelDuration) {
                animations(.from)
            }
        } else {
            // 完成返回手势的完成事件
            let finishDuration: TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            UIView.animate(withDuration: finishDuration) {
                animations(.to)
            }
        }
    }
}

extension UINavigationController: UINavigationBarDelegate {
    // MARK: 如果 topVC setNavigationBarHidden(true), UINavigationBar 不显示，该方法不会触发. iOS 13，无论如何不会触发
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        // MARK：通过手势返回
        if let topVC = topViewController, let coordinator = topVC.transitionCoordinator, coordinator.initiallyInteractive {
            coordinator.notifyWhenInteractionChanges({ (context) in
                self.dealInteractionChanges(context)
            })
            return true
        }
        // MARK: == nil
        let itemCount = navigationBar.items?.count ?? 0
        let count = viewControllers.count >= itemCount ? 2 : 1
        let popToVC = viewControllers[viewControllers.count - count]
        popToViewController(popToVC, animated: true)
        return true
    }
}
