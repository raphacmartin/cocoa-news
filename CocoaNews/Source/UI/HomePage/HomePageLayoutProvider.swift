final class HomePageLayoutProvider {
    // MARK: Private properties
    private let shouldUseSwiftUI: Bool
    
    // MARK: Initializer
    init(shouldUseSwiftUI: Bool) {
        self.shouldUseSwiftUI = shouldUseSwiftUI
    }
    
    public func getFeaturedNewsViewController() -> FeaturedNewsViewController {
        if shouldUseSwiftUI {
            return FeaturedNewsViewControllerSwiftUI(rootView: FeaturedNewsView())
        } else {
            return FeaturedNewsViewControllerUIKit()
        }
    }
}
