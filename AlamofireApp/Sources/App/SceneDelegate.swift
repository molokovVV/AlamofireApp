//
//  SceneDelegate.swift
//  AlamofireApp
//
//  Created by Виталик Молоков on 30.03.2023.
//

import UIKit
import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = ViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
