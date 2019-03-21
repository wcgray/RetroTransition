import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.black
        
        let navigationController = UINavigationController.init(rootViewController: PhotosGridViewController())
        navigationController.navigationBar.barStyle = .blackOpaque
        navigationController.setNavigationBarHidden(true, animated: false)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        return true
    }
}
