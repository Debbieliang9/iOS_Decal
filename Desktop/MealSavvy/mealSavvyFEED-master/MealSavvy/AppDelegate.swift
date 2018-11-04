//
//  AppDelegate.swift
//  MealSavvy
//
//  Created by AppsInvo Mac Mini 2 on 06/08/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKLoginKit
import UserNotifications
import SVProgressHUD
import GooglePlaces
import GoogleMaps

var DELEGATE : AppDelegate!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        UITabBar.appearance().tintColor = UIColor( red: CGFloat(49/255.0), green: CGFloat(170/255.0), blue: CGFloat(101/255.0), alpha: CGFloat(1.0) )
        
        GMSPlacesClient.provideAPIKey("AIzaSyB4YuZAeMoTnSV-Bfg7RsOR_HK-YDLuvZY")
       
        GMSServices.provideAPIKey("AIzaSyCfhqC_KgScFha_BgXU9g2d_5y8vGrcVyY")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKLoginManager.renewSystemCredentials { (result: ACAccountCredentialRenewResult, error: Error!) ->
            Void in
        }
        print(GlobalData.shared.me)

        // socket
        SocketService.shared.connect()
        // register notification
        registerRemoteNotification(application)
        // initialize progress hud
        initSVProgressHUD ()
        
        let stroruBoard = UIStoryboard.init(name: "Main", bundle: nil)
        print(GlobalData.shared.me)
        
        if GlobalData.shared.me != nil {
            let instance = stroruBoard.instantiateViewController(withIdentifier: "tabNavigation") as! UINavigationController
            self.window?.rootViewController = instance
        }else{
            let instance = stroruBoard.instantiateViewController(withIdentifier: "AuthNavigationController") as! UINavigationController
            self.window?.rootViewController = instance
        }
        
        DELEGATE = UIApplication.shared.delegate as! AppDelegate!
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication: String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApplication, annotation: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SocketService.shared.disconnect()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        GlobalData.shared.deviceToken = tokenParts.joined()
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    // MARK: - Remote Notification Handler
    private func registerRemoteNotification (_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            let pushNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(pushNotificationSettings)
            application.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // MARK: - Initialize SVProgressHUD
    private func initSVProgressHUD () {
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setBackgroundColor(.darkText)
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(3.0)
    }
}

