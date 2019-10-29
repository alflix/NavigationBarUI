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
        NavigationBarConfig.debugMode = true
        NavigationBarConfig.backIconImage = UIImage(named: "0")
        return true
    }
}
