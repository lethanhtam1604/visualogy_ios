//
//  AppDelegate.swift
//  VISUALOGYX
//
//  Created by Luu Nguyen on 9/22/16.
//  Copyright © 2016 Lavamy. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SimpleAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // crash report
        
        TestFairy.begin("58d25fe285fd19a49e154ba43fa2d24616b26257")
        
        // change status bar background color
        
        let statusView = application.valueForKey("statusBarWindow")!.valueForKey("statusBar") as? UIView
        statusView?.backgroundColor = Global.colorStatus
        
        // change navigation bar background color and tint color
        
        UINavigationBar.appearance().backgroundColor = Global.colorSelected
        UINavigationBar.appearance().setBackgroundImage(UIImage(named:"navBar.png"), forBarMetrics: .Default)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        // keyboard
        
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enable = true
        keyboardManager.shouldHidePreviousNext = true
        keyboardManager.shouldShowTextFieldPlaceholder = false
        
        // create new window

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
        self.window?.makeKeyAndVisible()

        // social
        
        configureAuthorizaionProviders()
        
        return true
    }
    
    func configureAuthorizaionProviders() {
        // app_id is required
        SimpleAuth.configuration()["facebook"] = ["app_id": ""]
        SimpleAuth.configuration()["facebook-web"] = ["app_id": ""]
        
        // client_id and client_secret are required
        SimpleAuth.configuration()["google-web"] = []
    }
}

