//
//  RealmHelper.swift
//  SecondAid
//
//  Created by Desmond Boey on 24/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    static func updateDistance(newDistance: Double){
        let realm = try! Realm()
        try! realm.write() {
            if realm.objects(RealmMap).first == nil {
                realm.add(RealmMap())
            }
            
            if let realmMap = realm.objects(RealmMap).first {
            realmMap.distance = newDistance
            }
        }
    }
    
    static func getDistance () -> Double {
        let realm = try! Realm()
        let realmMap = realm.objects(RealmMap).first
        return realmMap?.distance ?? 800
    }
    
    
}