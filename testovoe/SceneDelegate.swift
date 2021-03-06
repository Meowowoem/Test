//
//  SceneDelegate.swift
//  testovoe
//
//  Created by Anastasia on 20.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var viewController: UIViewController!
    let currentUser = UserDefaults.standard.string(forKey: "currentUser")
    
    let loginVC = LoginViewController()
    let profileVC = ProfileViewController()
    let groupVC = GroupViewController()
    let tabBarVC = UITabBarController()
    let userGroupVC = GroupUsersViewController()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        
        viewController = LoginViewController()
        
        groupVC.tabBarItem = UITabBarItem(title: "Группы", image: UIImage(named: "groupTab"), tag: 1)
        loginVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "profileTab"), tag: 0)
//        navController = UINavigationController(rootViewController: viewController)
        let firstNavController = UINavigationController(rootViewController: loginVC)
//        let secondNavController = UINavigationController(rootViewController: profileVC)
        let thirdNavController = UINavigationController(rootViewController: groupVC)
        //let fourthNavController = UINavigationController(rootViewController: userGroupVC)
        
        tabBarVC.setViewControllers([firstNavController, thirdNavController], animated: true)
        groupVC.view.reloadInputViews()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }


}

