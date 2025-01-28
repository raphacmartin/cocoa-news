import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var selectedCategories: [ArticleCategory] = []
}

// MARK: Public API
extension OnboardingViewModel {
    func save() {
        
    }
}
