import UIKit

public final class ViewFactory {
    let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    func buildHomeViewController() -> UIViewController {
        let shouldUseSwiftUI = configuration.retrieve(from: .useSwiftUI)
        let client = NewsAPIClient()
        let headlinesService = HeadlinesService(apiClient: client)
        let viewModel = HomePageViewModel(service: headlinesService)
        let layoutProvider = HomePageLayoutProvider(shouldUseSwiftUI: shouldUseSwiftUI)
        let homeVC = HomePageViewController(
            viewModel: viewModel,
            layoutProvider: layoutProvider
        )
        // Ensure navigation works for detail pages
        return UINavigationController(rootViewController: homeVC)
    }
    
    func buildOnboardingViewController() -> UIViewController {
        OnboardingHostingController()
    }
}
