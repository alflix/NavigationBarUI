//
//  ViewController.swift
//  Demo
//
//  Created by John on 2019/3/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import Reusable

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationAppearance.barTintColor = .white
    }

    @IBAction func colorValueChange(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            navigationAppearance.barTintColor = .green
        case 1:
            navigationAppearance.barTintColor = .red
        case 2:
            navigationAppearance.barTintColor = .white
        case 3:
            navigationAppearance.barTintColor = .blue
        case 4:
            navigationAppearance.barTintColor = .black
        default:
            ()
        }
    }

    @IBAction func shadowHiddenValueChange(_ sender: UISwitch) {
        navigationAppearance.isShowShadowLine = !sender.isOn
    }

    @IBAction func blackBarStyleValueChange(_ sender: UISwitch) {

    }

    @IBAction func sliderValueChange(_ sender: UISlider) {
        navigationAppearance.backgroundAlpha = CGFloat(sender.value)
    }

    @IBAction func pushToNext() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ViewController")
        navigationController?.pushViewController(viewController!, animated: true)
    }
}
