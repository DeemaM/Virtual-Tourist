//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Deema  on 04/07/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     DataController.shared.load()
        return true
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
       saveViewContext()    }
    

    func saveViewContext() {
        try? DataController.shared.viewContext.save()
    }
    



}

