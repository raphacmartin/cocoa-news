//
//  SceneDelegate.swift
//  CocoaNews
//
//  Created by Raphael Martin on 29/07/24.
//

import RxSwift
import UIKit
import UnleashProxyClientSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: Public properties
    public var window: UIWindow?
    
    // MARK: Private properties
    private var disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupWindow(with: scene)
    }
}

// MARK: - App Loading
extension SceneDelegate {
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        let splashVC = SplashScreenViewController()
        self.window?.rootViewController = splashVC
        self.window?.makeKeyAndVisible()
        
        subscribeToLoadingFinish(with: splashVC)
    }
    
    private func subscribeToLoadingFinish(with viewController: SplashScreenViewController) {
        viewController.didFinishLoading
            .subscribe(onNext: { configuration in
                let shouldUseSwiftUI = configuration.retrieve(from: .useSwiftUI)
                
                self.window?.rootViewController = self.buildHomeViewController(shouldUseSwiftUI: shouldUseSwiftUI)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Views creation
extension SceneDelegate {
    private func buildHomeViewController(shouldUseSwiftUI: Bool) -> UIViewController {
        let client = NewsAPIClient()
        let everythingService = EverythingService(apiClient: client)
        let viewModel = HomePageViewModel(service: everythingService)
        let layoutProvider = HomePageLayoutProvider(shouldUseSwiftUI: shouldUseSwiftUI)
        
        return HomePageViewController(
            viewModel: viewModel,
            layoutProvider: layoutProvider
        )
    }
}

