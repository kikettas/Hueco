//
//  AppDelegate.swift
//  InfiniteLoopers
//
//  Created by Enrique del Pozo Gómez on 2/3/17.
//  Copyright © 2017 Infinite Loopers. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit
import GoogleSignIn
import Swarkn
import RxCocoa
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        AppManager.initialize()
        AppManager.shared.isInitialized.subscribe(onCompleted:{
            self.loadFirstView()
        }).addDisposableTo(disposeBag)

        keepLaunchScreenUntilInitialized()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if(url.scheme == "fb1899195456980029"){
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        }else{
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        }
    }
    
    func loadFirstView(){
        let mainTabBarController = MainTabBarV(nibName: nil, bundle: nil)
        Navigator.changeRootViewController(with: mainTabBarController, color: .white, transition: .transitionCrossDissolve)
    }
    
    func keepLaunchScreenUntilInitialized(){
        let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "launchV")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = launchScreen
        self.window?.makeKeyAndVisible()
    }
}

