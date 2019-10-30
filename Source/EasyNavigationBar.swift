//
//  EasyNavigationBar.swift
//  Demo
//
//  Created by John on 2019/10/29.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

open class EasyNavigationBar: UINavigationBar {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBackgroundAlpha(0)
    }

    func setup() {
        setupBackgroundAlpha(0)
    }
}
