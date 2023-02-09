//
//  AppDelegate.swift
//  Swift_Sudoku_Solver
//
//  Created by NowOrNever on 09/04/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

import UIKit
import STSwiftIAP

let sudokuVersionKey = "varsion"
let sudokuVersion = "1.0"
let product_id_vip = "com.LL.SudokuSolver.VIP"

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.groupTableViewBackground
        let vc = DLSolverViewController()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        setNav(nav: nav)
//        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarStyle = .lightContent
//        print(self)
//        print(UIApplication.shared)
        // Override point for customization after application launch.
        
        AccountInfo.shared.start()
        
        let _ = STSwiftIAP.shared.start(productIds: [product_id_vip])

        return true
    }
    
    fileprivate func setNav(nav:UINavigationController){
        nav.navigationBar.setBackgroundImage(UIImage(), for: .top, barMetrics: .default)
        nav.navigationBar.shadowImage = UIImage()
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

