import Foundation

enum StyleGuide {
    static let pageHorizontalPadding: CGFloat = 20
    static let pageVerticalPadding: CGFloat = 20
    
    static let internalVerticalPadding: CGFloat = 12
    
    static let loadingAnimationDuration = 2.0
    
    static let contentViewRadius = 35.0
    
    enum Onboarding {
        static let logoSize: CGFloat = 100
    }
    
    enum SelectableItem {
        static let height: CGFloat = 40
        static let radius: CGFloat = 20
        static let padding: CGFloat = 20
        static let spacing: CGFloat = 16
    }
    
    enum FeaturedNews {
        static let cardWidth: CGFloat = 200
        static let cardHeight: CGFloat = 200
        static let cardCornerRadius: CGFloat = 10
        static let cardShadowOpacity: Double = 0.5
        static let cardShadowRadius: CGFloat = 3
        static let imageHeight: CGFloat = 130
    }
}
