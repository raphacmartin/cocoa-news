import RxSwift

extension EverythingService: ReactiveCompatible { }

extension Reactive where Base: EverythingService {
    func search(with query: String) -> Single<NewsAPIResponse> {
        Single.create { single in
            let networkTask = base.search(with: query) { single($0) }
            
            return Disposables.create {
                networkTask.cancel()
            }
        }
    }
}
