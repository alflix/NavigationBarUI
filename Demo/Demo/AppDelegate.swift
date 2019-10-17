//
//  AppDelegate.swift
//  Demo
//
//  Created by John on 2019/3/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.backgroundColor = .white
        UIViewController.swizzleViewWillAppear()
        UINavigationController.swizzle()
        GGUI.NavigationBarConfig.backIconImage = UIImage(named: "0")
        return true
    }
}

public extension UIView {
    /// 递归查找子类 UIView
    ///
    /// - Parameter name: UIView 的类名称
    /// - Returns: 找到的 UIView
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

public func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedSame
}

public func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedDescending
}

public func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
}

public func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedAscending
}

public func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {
    return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedDescending
}

public extension DispatchQueue {
    private static var onceTracker = [String]()

    static func once(file: String = #file, function: String = #function, line: Int = #line, block: () -> Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }

    static func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}

/// 封装 swizzed 方法
public let swizzling: (AnyClass, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

public extension NSObject {
    /// Sets an associated value for a given object using a weak reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    func associate(assignObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_ASSIGN)
        didChangeValue(forKey: strKey)
    }

    /// Sets an associated value for a given object using a strong reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    func associate(retainObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        didChangeValue(forKey: strKey)
    }

    /// Sets an associated value for a given object using a copied reference to the associated object.
    /// **Note**: the `key` underlying type must be String.
    func associate(copyObject object: Any?, forKey key: UnsafeRawPointer) {
        let strKey: String = convertUnsafePointerToSwiftType(key)
        willChangeValue(forKey: strKey)
        objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        didChangeValue(forKey: strKey)
    }

    /// Returns the value associated with a given object for a given key.
    /// **Note**: the `key` underlying type must be String.
    func associatedObject(forKey key: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, key)
    }
}

public func convertUnsafePointerToSwiftType<T>(_ value: UnsafeRawPointer) -> T {
    return value.assumingMemoryBound(to: T.self).pointee
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

    static var defaultBlue: UIColor {
        return UIColor.init(hexString: "0x007aff")!
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

public struct GGUI {
    /// 横线配置
    public enum LineView {
        /// 颜色
        public static var color: UIColor = .lightGray
        /// 线宽
        public static var lineWidth: CGFloat = 1.0
    }

    /// 导航栏配置
    public enum NavigationBarConfig {
        /// 返回按钮的图片
        public static var backIconImage: UIImage?
        /// 样式（透明度，颜色，分割线等）
        public static var appearance: NavigationAppearance = NavigationAppearance()
    }
}

public typealias DelayTask = (_ cancel: Bool) -> Void

/// 延时执行任务
///
/// - Parameters:
///   - time: 秒数
///   - task: 任务
/// - Returns: 可取消的 Block
@discardableResult
public func delay(_ time: TimeInterval, task: @escaping () -> Void) -> DelayTask? {
    func dispatch_later(block: @escaping () -> Void) {
        let after = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: after, execute: block)
    }

    var closure: (() -> Void)? = task
    var result: DelayTask?

    let delayedClosure: DelayTask = { cancel in
        if let internalClosure = closure, !cancel {
            DispatchQueue.main.async(execute: internalClosure)
        }
        closure = nil
        result = nil
    }

    result = delayedClosure

    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}
