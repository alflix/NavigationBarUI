//
//  CustomButton.swift
//  Ganguo
//
//  Created by John on 2019/3/12.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

@IBDesignable public class CustomButton: UIButton {
    /// 置灰时的 alpha
    public var disableAlpha: CGFloat = GGUI.CustomButton.disableAlpha
    /// 文字的行数
    @IBInspectable public var numberOfLines: Int = 1 {
        didSet {
            self.titleLabel?.numberOfLines = numberOfLines
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override public var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : disableAlpha
        }
    }
}
