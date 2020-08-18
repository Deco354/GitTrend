//
//  SceneDelegate.swift
//  GitTrend
//
//  Created by Declan McKenna on 15/08/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let windowScene = UIWindowScene(session: session, connectionOptions: connectionOptions)
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = makeRootViewController()
        self.window?.makeKeyAndVisible()
    }
    
    private func makeRootViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let repoListViewController = storyboard.instantiateViewController(identifier: "RepoListViewController") { coder in
            RepoListViewController(coder: coder, api: GitTrendAPI())
        }
        return UINavigationController(rootViewController: repoListViewController)
    }
}

