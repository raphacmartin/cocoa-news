import UIKit
import RxSwift

// MARK: Protocol
protocol NavigationManaging {
    var viewFactory: ViewFactory? { get set }
    
    func presentSplashScreenUntilFinished(on window: UIWindow) -> Observable<Void>
    func setRootPage(_ rootPage: RootPage)
}

final class NavigationManager {
    // MARK: Singleton
    static var shared = NavigationManager()
    
    // MARK: Private Properties
    var window: UIWindow? = nil
    
    // MARK: Public properties
    var viewFactory: ViewFactory?
    
    fileprivate init() {}
}

// MARK: NavigationManaging conformance
extension NavigationManager: NavigationManaging {
    func presentSplashScreenUntilFinished(on window: UIWindow) -> Observable<Void> {
        self.window = window
        
        let splashVC = SplashScreenViewController()
        self.window?.rootViewController = splashVC
        self.window?.makeKeyAndVisible()
        
        return splashVC.videoDidFinish
    }
    
    func setRootPage(_ rootPage: RootPage) {
        guard let viewFactory = viewFactory else {
            fatalError("View factory not set.")
        }
        
        switch rootPage {
        case .onboarding:
            window?.rootViewController = viewFactory.buildOnboardingViewController()
        case .home:
            window?.rootViewController = viewFactory.buildHomeViewController()
        }
    }
}

// MARK: RootPages
enum RootPage {
    case onboarding
    case home
}
