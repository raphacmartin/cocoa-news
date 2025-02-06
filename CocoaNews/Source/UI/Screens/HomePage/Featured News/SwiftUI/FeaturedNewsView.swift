import SwiftUI

struct FeaturedNewsView: View {
    @ObservedObject var viewModel = FeaturedNewsViewModel()
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text("Featured News (SwiftUI)")
                .font(.custom("ArialRoundedMTBold", size: 24))
                .foregroundColor(.secondary)
                .padding(.horizontal, StyleGuide.pageHorizontalPadding)
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(viewModel.articles) {
                        FeaturedNewsItem(article: $0)
                    }
                }
                .padding(.vertical, StyleGuide.internalVerticalPadding)
            }
            .safeAreaPadding(.horizontal, StyleGuide.pageHorizontalPadding)
        }
        .padding(.top, StyleGuide.pageVerticalPadding)
    }
}

// MARK: Public API
extension FeaturedNewsView {
    public func set(articles: [Article]) {
        viewModel.articles = articles
    }
}

extension Article: Identifiable {
    var id: String {
        "\(self.title)|\(self.url)"
    }
}

#Preview {
    FeaturedNewsView()
}
