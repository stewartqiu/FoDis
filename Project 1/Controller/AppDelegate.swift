//
//  AppDelegate.swift
//  Project 1
//
//  Created by SchoolDroid on 12/2/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
import Firebase
import UserNotifications
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        DropDown.startListeningToKeyboard()
        
        GMSServices.provideAPIKey("AIzaSyBldo0KyVVsZ3IJ07G33s1SWs_PD3fLlO0")
        
        UserDefaults.standard.set(["id"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        FirebaseApp.configure()
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge , .sound , .alert], completionHandler: { (granted, error) in
                if let error = error {
                    print("Error \(error)")
                }
            });
            application.registerForRemoteNotifications()
        } else{
            let notificationSettings = UIUserNotificationSettings(types: [.badge , .sound , .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        
        //let _ = SettingLite().insertData(keyfile: SettingKey.isTest, value: "0")
        
        var identifier = String()
        
        let isTest = SettingLite().getFiltered(keyfile: SettingKey.isTest)
        if isTest == nil || isTest == ""{
            DummyData.inject()
            identifier = "mainNavController"
        }
        else if isTest == "0" {
            if (SettingLite().getFiltered(keyfile: SettingKey.id) == nil) {
                identifier = "regisNavController"
            } else if SettingLite().getFiltered(keyfile: SettingKey.nama) == nil || SettingLite().getFiltered(keyfile: SettingKey.nama)! == ""{
                identifier = "profilNavController"
            }
            else {
                identifier = "mainNavController"
            }
        } else {
            identifier = "mainNavController"
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: identifier) as! UINavigationController
        
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

