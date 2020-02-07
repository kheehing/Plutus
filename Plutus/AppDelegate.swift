//
//  AppDelegate.swift
//  Plutus
//
//  Created by ITP312 on 28/11/19.
//  Copyright © 2019 NYP. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import ApiAI
import Braintree

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let configuration = AIDefaultConfiguration()
        configuration.clientAccessToken = "e790769966ca4113a4df364257f01631"
        let apiai = ApiAI.shared()
        apiai?.configuration = configuration
        FirebaseApp.configure()
        BTAppSwitch.setReturnURLScheme("com.nyp.plutus.payments")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let blankViewController:UIViewController = UIViewController()
        blankViewController.view.backgroundColor = UIColor.white
        self.window!.rootViewController!.showDetailViewController(blankViewController, sender: nil)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.window!.rootViewController!.dismiss(animated: false)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Plutus")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare("com.nyp.plutus.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        return false
    }

}
