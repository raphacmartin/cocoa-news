import RxCocoa
import RxSwift

final class HomePageViewModel {
    let service: EverythingService
    
    internal init(service: EverythingService) {
        self.service = service
    }
}

// MARK: ViewModel conformance
extension HomePageViewModel: ViewModel {
    struct Input {
        let loadFeaturedNews: Observable<Void>
        let loadLatestNews: Observable<Void>
    }
    
    struct Output {
        let featuredNews: Observable<NewsAPIResponse>
        let latestNews: Observable<NewsAPIResponse>
    }
    
    func connect(input: Input) -> Output {
        let featuredNews = input.loadFeaturedNews
            .flatMapLatest { [service] _ in
                service.rx.search(with: "technology")
            }
        
        let latestNews = input.loadLatestNews
            .flatMapLatest { [service] _ in
                service.rx.search(with: "elections")
            }
        
        return Output(
            featuredNews: featuredNews.observe(on: MainScheduler.instance),
            latestNews: latestNews.observe(on: MainScheduler.instance)
        )
    }
}
