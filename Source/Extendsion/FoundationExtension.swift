//
//  FoundationExtension.swift
//  EasyNavigationBar
//
//  Created by John on 2019/10/29.
//  Copyright © 2019 John. All rights reserved.
//

import Foundation

typealias DelayTask = (_ cancel: Bool) -> Void

extension DispatchQueue {
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

    @discardableResult
    static func delay(_ time: TimeInterval, task: @escaping () -> Void) -> DelayTask? {
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
}

extension NSObject {
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

    func convertUnsafePointerToSwiftType<T>(_ value: UnsafeRawPointer) -> T {
        return value.assumingMemoryBound(to: T.self).pointee
    }
}

/// 封装 swizzed 方法
let swizzling: (AnyClass, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

func DPrint<N>(_ message: N, file: String = #file, function: String = #function, line: Int = #line) {
    guard Config.debugMode else {
        return
    }
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("😋 \(fileName):\(line) \(function) | \(message)")
    #endif
}
