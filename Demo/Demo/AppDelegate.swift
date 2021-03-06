//
//  AppDelegate.swift
//  Demo
//
//  Created by John on 2019/3/20.
//  Copyright © 2019 NavigationBarUI. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.backgroundColor = .white
        configNavigationUI()
        return true
    }

    func configNavigationUI() {
        UIViewController.swizzleViewWillAppear()
        UINavigationController.swizzle()
        Config.debugMode = true
        Config.backIconImage = UIImage(named: "0")
    }
}
