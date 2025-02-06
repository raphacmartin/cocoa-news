import SwiftUI

final class FeaturedNewsViewControllerSwiftUI: UIHostingController<FeaturedNewsView> {
    override init(rootView: FeaturedNewsView) {
        super.init(rootView: rootView)
        
        view.backgroundColor = .clear
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("🔥")
    }
}

// MARK: - FeaturedNewsViewController conformance
extension FeaturedNewsViewControllerSwiftUI: FeaturedNewsViewController {
    public func set(articles: [Article]) {
        rootView.set(articles: articles)
    }
}
