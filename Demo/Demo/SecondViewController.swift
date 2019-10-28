//
//  SecondViewController.swift
//  Demo
//
//  Created by John on 2019/10/17.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import Reusable

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationAppearance.backgroundAlpha = 0
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "5")?.original, style: .plain, target: self, action: #selector(pop))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "2"), style: .plain, target: self, action: #selector(push))
    }

    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }

    @objc func push() {
        navigationController?.pushViewController(ViewController(), animated: true)
    }
}
