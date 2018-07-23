//
//  AppDelegate.swift
//  Todoey
//
//  Created by Noah Eaton on 7/4/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //location of realm file
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
    
        do {
            //initialize Realm
             _ = try Realm()
        } catch {
            print("Error with initialization of realm \(error)")
        }
        
        
        return true
    }
    
}

