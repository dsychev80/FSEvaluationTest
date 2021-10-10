//
//  SceneDelegate.swift
//  ForaSoftEvaluationTestDemo
//
//  Created by Denis Sychev on 10/7/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    struct Constants {
        static let storyboardName = "Main"
    }

    var window: UIWindow?
    var dataController: DataController?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        dataController = DataController()
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let tabBarViewController = UIStoryboard(name: Constants.storyboardName, bundle: .main).instantiateViewController(identifier: MainTabBarController.name, creator: { [weak self] (coder) -> MainTabBarController? in
            guard let dataControler = self?.dataController else {
                return MainTabBarController(coder: coder)
            }
            return MainTabBarController(coder: coder, dataController: dataControler)
        }) 
        window.rootViewController = tabBarViewController
        window.makeKeyAndVisible()
    }    
}

