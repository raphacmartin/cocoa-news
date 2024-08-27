import Combine

class FeaturedNewsViewModel: ObservableObject {
    @Published var articles = [Article]()
}
