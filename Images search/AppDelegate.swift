//
//  AppDelegate.swift
//  Images search
//
//  Created by Ivan Solohub on 19.02.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NetworkMonitor.shared.startMonitoring()
        return true
    }
}

