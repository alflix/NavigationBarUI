//
//  ViewController.swift
//  Demo
//
//  Created by John on 2019/3/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "1"), style: .plain, target: self, action: #selector(push))
    }

    @objc func push() {
        navigationController?.pushViewController(SecondViewController(), animated: true)
    }
}