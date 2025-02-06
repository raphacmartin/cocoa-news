import UIKit

public final class ViewFactory {
    let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    func buildHomeViewController() -> UIViewController {
        let shouldUseSwiftUI = configuration.retrieve(from: .useSwiftUI)
        
        let client = NewsAPIClient()
        let everythingService = EverythingService(apiClient: client)
        let viewModel = HomePageViewModel(service: everythingService)
        let layoutProvider = HomePageLayoutProvider(shouldUseSwiftUI: shouldUseSwiftUI)
        
        return HomePageViewController(
            viewModel: viewModel,
            layoutProvider: layoutProvider
        )
    }
    
    func buildOnboardingViewController() -> UIViewController {
        OnboardingHostingController()
    }
}
