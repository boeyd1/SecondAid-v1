//
//  AppDelegate.swift
//  SecondAid
//
//  Created by Desmond Boey on 7/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import ParseUI



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var oneSignal : OneSignal?
    
    var parseLoginHelper : ParseLoginHelper!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //registerForPushNotifications(application)
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "secondaid"
            $0.server = "https://secondaid.herokuapp.com/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let startViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = startViewController;
        self.window?.makeKeyAndVisible()
        
        let acl = PFACL()
        
        
        //all users can read the data
        acl.publicReadAccess = true
        acl.publicWriteAccess = true

        //only provide write access to the user that created the object
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
     
        self.oneSignal = OneSignal(launchOptions: launchOptions, appId: "fa1b2714-7f81-4ef0-bc38-7a50cab4f525", handleNotification: nil,autoRegister: false)
        
        OneSignal.defaultClient().enableInAppAlertNotification(true)

        return true
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        NotificationHelper.notification.postNotificationName(NotificationHelper.ntfnAppEnteredForeground, object: self)

    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        LocMgr.sharedInstance.stopUpdatingLocation()
        
    }
   
}

/*
 
 func registerForPushNotifications(application: UIApplication) {
 let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
 application.registerUserNotificationSettings(notificationSettings)
 }
 
 
 //if user disables all 3 types above then ask them to register again. if at least 1 is enabled, skip this
 func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
 if notificationSettings.types != .None {
 application.registerForRemoteNotifications()
 }
 }
*/
