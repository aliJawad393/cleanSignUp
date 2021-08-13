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
        let controller =  SignUpViewController(builder: builder, signUpBlock: {[weak navController] modifiedBuilder in
            do {
                let _ = try modifiedBuilder.build()
                navController?.topViewController?.alert("Success", message: "Entered info was valid")
            } catch(let error) {
                navController?.topViewController?.alert("Error", message: error.localizedDescription)
            }
        })
        navController.viewControllers = [controller]
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}

