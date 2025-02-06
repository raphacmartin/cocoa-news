enum ArticleCategory: String, CaseIterable, Codable {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}

// MARK: - DescritiveItem conformance
extension ArticleCategory: DescriptiveItem {
    var id: ArticleCategory {
        self
    }
    
    var description: String {
        switch self {
        case .business:
            "🧳 Business"
        case .entertainment:
            "🍿 Entertainment"
        case .general:
            "⚙️ General"
        case .health:
            "🏥 Health"
        case .science:
            "🧪 Science"
        case .sports:
            "⚽️ Sports"
        case .technology:
            "💻 Technology"
        }
    }
}
