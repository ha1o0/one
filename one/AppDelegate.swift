//
//  AppDelegate.swift
//  one
//
//  Created by sidney on 2021/3/20.
//

import UIKit
import CoreData
import AVKit

#if DEBUG
    import DoraemonKit
#endif

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: BaseWindow?
    var launchWindow: UIWindow?
    var musicWindow: MusicPlayerWindow?
    var deviceOrientation = UIInterfaceOrientationMask.all
    var rootVc: MainViewController?
    var musicVc: MusicPlayerViewController = MusicPlayerViewController()
    var currentPlayer: AVPlayer?
    var currentPlayerLayer: AVPlayerLayer?
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return deviceOrientation
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = BaseWindow(frame: UIScreen.main.bounds)
//        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.main
        rootVc = MainViewController()
        window?.rootViewController = rootVc
        window?.makeKeyAndVisible()

        let frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.musicWindow = MusicPlayerWindow(frame: frame)
        self.showLaunchWindow()
        
//        #if DEBUG
//        DoraemonManager.shareInstance().install(withStartingPosition: CGPoint(x: SCREEN_WIDTH - 100, y: 100))
//        #endif
        
        return true
    }

    func showLaunchWindow() {
        launchWindow = UIWindow(frame: UIScreen.main.bounds)
        let launchNavigationViewController = BaseNavigationViewController.init(rootViewController: LaunchViewController())
        launchWindow?.rootViewController = launchNavigationViewController;
        launchWindow?.makeKeyAndVisible()
    }
    
    func cancelLaunchWindow() {
        self.launchWindow?.resignKey()
        self.launchWindow = nil
    }

    // MARK: AppDelegate LifeCycle
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("resignactive")
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.main
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("didenterback")
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.main
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // 保持后台播放
        self.currentPlayerLayer?.player = nil
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("WillEnterForeground")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // 恢复播放器画面
        self.currentPlayerLayer?.player = self.currentPlayer
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("DidBecomeActive")
        ThemeManager.shared.updateInterfaceStyle()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("WillTerminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        print("configurationForConnecting")
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        print("didDiscardSceneSessions")
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "one")
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

}

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 3848245
            let keyWindow: UIWindow? = appDelegate.window
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                let statusBarView = UIView(frame: height)
                statusBarView.tag = tag
                statusBarView.layer.zPosition = 999999
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
    
    
}

extension AppDelegate {
    func hideStatusBar() {
        UIApplication.shared.statusBarUIView?.isHidden = true
    }

    func showStatusBar() {
        UIApplication.shared.statusBarUIView?.isHidden = false
    }
}
