//
//  NotificationHelper.swift
//  SecondAid
//
//  Created by Desmond Boey on 21/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation

class NotificationHelper {
    
    static let notification = NSNotificationCenter.defaultCenter()
    static let ntfnInitialLocationSet = "initialLocationSet"
    static let ntfnAppEnteredForeground = "appEnteredForeground"
}

/*

//put in relevant view controller

@IBAction func doNotify(sender: AnyObject){
    
    NotificationHelper.notification.postNotificationName(NotificationHelper.ntfnBroadcast, object: self)
}

//in VC viewdidload()
NotificationHelper.notification.addObserver(self, selector: "doAnAction", name: NotificationHelper.ntfnBroadcast, object: nil)


//in all relevant VCs add following function: but each one can have a unique actions (must have same name)
func doAnAction () {
    myLabel.tet = "I got notified"
    //or whatever action
}
 */