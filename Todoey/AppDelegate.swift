//
//  AppDelegate.swift
//  Todoey
//
//  Created by Noah Eaton on 7/4/18.
//  Copyright © 2018 Noah Eaton. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
        self.saveContext()
        
    }
    
    // MARK: - Core Data stack
    
    //lazy variables only get loaded up with a value when needed, this creates memory benefits
    //NSPersistentContainer encloses the Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        //create a new container using CoreData, database we are saving to.
        let container = NSPersistentContainer(name: "DataModel")
        //load the persistent store and get it ready for use
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                //fatalError stops the program and prints the error to the console
                fatalError("Unresolved error \(error), \(error.userInfo)")
            
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    //saves data when app is terminated
    func saveContext () {
        //context is area where data can be changed and updated, until you are happy with the data
        //then you can save it to permenant storage
        let context = persistentContainer.viewContext
        //hasChanges is a bool value which changes when edits are made
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                //NSError is a domain-specific error
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

