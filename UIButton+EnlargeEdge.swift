//
//  UIButton+Extension.swift
//  Ganguo
//
//  Created by John on 2018/12/11.
//  Copyright © 2018 Ganguo. All rights reserved.
//

import UIKit

public extension UIButton {
    fileprivate struct AssociatedKeys {
        static var topKey: UInt8 = 0
        static var bottomKey: UInt8 = 0
        static var leftKey: UInt8 = 0
        static var rightKey: UInt8 = 0
    }

    var largeTop: NSNumber {
        get {
            return associatedObject(base: self, key: &AssociatedKeys.topKey) { return 0 }
        }
        set {
            associateObject(base: self, key: &AssociatedKeys.topKey, value: newValue)
        }
    }

    var largeBottom: NSNumber {
        get {
            return associatedObject(base: self, key: &AssociatedKeys.bottomKey) { return 0 }
        }
        set {
            associateObject(base: self, key: &AssociatedKeys.bottomKey, value: newValue)
        }
    }

    var largeLeft: NSNumber {
        get {
            return associatedObject(base: self, key: &AssociatedKeys.leftKey) { return 0 }
        }
        set {
            associateObject(base: self, key: &AssociatedKeys.leftKey, value: newValue)
        }
    }

    var largeRight: NSNumber {
        get {
            return associatedObject(base: self, key: &AssociatedKeys.rightKey) { return 0 }
        }
        set {
            associateObject(base: self, key: &AssociatedKeys.rightKey, value: newValue)
        }
    }

    /// 增加 UIButton 的点击范围
    ///
    /// - Parameters:
    ///   - top: 上
    ///   - bottom: 下
    ///   - left: 左
    ///   - right: 右
    func setEnlargeEdge(top: Float, bottom: Float, left: Float, right: Float) {
        self.largeTop = NSNumber(value: top)
        self.largeBottom = NSNumber(value: bottom)
        self.largeLeft = NSNumber(value: left)
        self.largeRight = NSNumber(value: right)
    }

    func enlargedRect() -> CGRect {
        let top = self.largeTop
        let bottom = self.largeBottom
        let left = self.largeLeft
        let right = self.largeRight
        if top.floatValue >= 0, bottom.floatValue >= 0, left.floatValue >= 0, right.floatValue >= 0 {
            return CGRect(x: self.bounds.origin.x - CGFloat(left.floatValue),
                          y: self.bounds.origin.y - CGFloat(top.floatValue),
                          width: self.bounds.size.width + CGFloat(left.floatValue) + CGFloat(right.floatValue),
                          height: self.bounds.size.height + CGFloat(top.floatValue) + CGFloat(bottom.floatValue))
        } else {
            return self.bounds
        }
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.enlargedRect()
        if rect.equalTo(self.bounds) {
            return super.point(inside: point, with: event)
        }
        return rect.contains(point) ? true : false
    }
}
