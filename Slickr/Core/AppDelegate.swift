//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let dependencies = Dependencies.resolve()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let photoCellFactory = DefaultPhotoCellFactory(imageService: dependencies.imageService)
        let searchScreenFactory = DefaultSearchScreenFactory(feedService: dependencies.feedService, photoCellFactory: photoCellFactory)
        let searchViewController = searchScreenFactory.createSearchScreen().asViewController
        let navigationController = UINavigationController(rootViewController: searchViewController)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
