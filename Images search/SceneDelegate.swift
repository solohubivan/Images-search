//
//  SceneDelegate.swift
//  Images search
//
//  Created by Ivan Solohub on 19.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var networkMonitor: NetworkMonitor?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        networkMonitor = NetworkMonitor()
        networkMonitor?.startMonitoring()
        
        let mainViewController = MainViewController()
        mainViewController.networkMonitor = networkMonitor

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
}

