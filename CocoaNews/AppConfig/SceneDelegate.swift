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
    private var sessionManager = SessionManager()
    private var navigationManager: NavigationManaging = NavigationManager.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupWindow(with: scene)
    }
}

// MARK: - App Loading
extension SceneDelegate {
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        guard let window = window else { return }
        
        let splashVideoDidFinish = navigationManager.presentSplashScreenUntilFinished(on: window)
        
        // Wait for both splash video and configuration loading finish to go to the first page
        Observable.combineLatest(
            splashVideoDidFinish,
            ConfigurationManager.start().asObservable()
        )
        // Discard the value from the splash Observable and use only the configuration
        .map { $0.1 }
        .subscribe(onNext: goToInitialPage(basedOn:))
        .disposed(by: disposeBag)
    }
    
    private func goToInitialPage(basedOn configuration: Configuration) {
        navigationManager.viewFactory = ViewFactory(configuration: configuration)
        
        if sessionManager.isSessionValid() {
            navigationManager.setRootPage(.home)
        } else {
            sessionManager.startSession()
            navigationManager.setRootPage(.onboarding)
        }
    }
}

