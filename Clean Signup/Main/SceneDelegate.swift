import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let builder = UserCrendentialsBuilder()
        let navController = UINavigationController()
        navController.navigationBar.isHidden = true
       let factory = iOSViewControllerFactory()
        
        navController.viewControllers = [factory.createSignupViewController(builder: builder)]
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}

