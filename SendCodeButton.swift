//
//  SendCodeButton.swift
//  Ganguo
//
//  Created by John on 2019/3/12.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import SwiftTimer

public class CountdownButton: CustomButton {
    private var timer: SwiftCountDownTimer?
    /// 未倒数时文字
    private var normalTitle: String?
    /// xxx秒，「秒」这个文字的设置
    @IBInspectable public var secondsTitle = GGUI.CountdownButton.secondsTitle
    /// 总秒数
    @IBInspectable public var seconds = GGUI.CountdownButton.seconds
    /// 倒数时显示的文字（不包含「xxx秒」部分的文字）
    @IBInspectable public var disableTitle: String = GGUI.CountdownButton.disableTitle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init(frame: CGRect) {
        super.init(frame: frame)
    }

    override public func setTitle(_ title: String?, for state: UIControl.State) {
        if state == .normal {
            normalTitle = title
        }
        super.setTitle(title, for: state)
    }

    override public var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            if isEnabled {
                layer.borderColor = titleColor(for: .normal)?.cgColor
            } else {
                layer.borderColor = titleColor(for: .disabled)?.cgColor
            }
        }
    }

    /// 开始倒计时
    public func startTimer() {
        guard isEnabled else { return }
        timer = SwiftCountDownTimer(interval: .fromSeconds(1), times: seconds, handler: { [weak self] (_, seconds) in
            guard let strongSelf = self else { return }
            if seconds > 0 {
                strongSelf.setupDisableCodeTitle(left: seconds)
            } else {
                strongSelf.setupNormalCodeTitle()
            }
        })
        timer?.start()
    }

    /// 结束倒计时
    public func invalidateTimer() {
        timer = nil
        setupNormalCodeTitle()
    }

    private func setupNormalCodeTitle() {
        isEnabled = true
        setTitle(normalTitle, for: .normal)
    }

    private func setupDisableCodeTitle(left: Int) {
        isEnabled = false
        let disableTitlePrex = self.disableTitle.count > 0 ? (self.disableTitle + "") : ""
        let disableTitle = disableTitlePrex + "\(left)" + secondsTitle
        setTitle(disableTitle, for: .disabled)
    }
}
