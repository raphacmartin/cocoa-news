import RxCocoa
import RxSwift

final class HomePageViewModel {
    let service: HeadlinesService
    
    internal init(service: HeadlinesService) {
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
        let featuredNews: Observable<Headlines>
        let latestNews: Observable<Headlines>
    }
    
    func connect(input: Input) -> Output {
        let featuredNews = input.loadFeaturedNews
            .flatMapLatest { [service] _ in
                service.rx.get(with: .technology)
            }
        
        let latestNews = input.loadLatestNews
            .flatMapLatest { [service] _ in
                service.rx.get(with: .general)
            }
        
        return Output(
            featuredNews: featuredNews.observe(on: MainScheduler.instance),
            latestNews: latestNews.observe(on: MainScheduler.instance)
        )
    }
}
