import Combine

final class OnboardingViewModel: ObservableObject {
    // MARK: Published vars
    @Published var selectedCategories: [ArticleCategory] = []
    
    // MARK: Private Constants
    private let sessionManager = SessionManager()
}

// MARK: Public API
extension OnboardingViewModel {
    func save() {
        sessionManager.setFavoriteCategories(selectedCategories)
    }
}
