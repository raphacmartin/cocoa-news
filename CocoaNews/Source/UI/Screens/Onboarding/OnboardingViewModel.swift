import Combine

final class OnboardingViewModel: ObservableObject {
    // MARK: Published vars
    @Published var selectedCategories: [ArticleCategory] = []
    
    // MARK: Private Constants
    private let sessionManager = SessionManager()
    private let navigationManager: NavigationManaging
    
    // MARK: Initializer
    init(navigationManager: NavigationManaging = NavigationManager.shared) {
        self.navigationManager = navigationManager
    }
}

// MARK: Public API
extension OnboardingViewModel {
    func save() {
        sessionManager.setFavoriteCategories(selectedCategories)
        
        navigationManager.setRootPage(.home)
    }
}
