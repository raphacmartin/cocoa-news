import RxSwift

extension HeadlinesService: ReactiveCompatible { }

extension Reactive where Base: HeadlinesService {
    func get(with category: ArticleCategory) -> Single<Headlines> {
        Single.create { single in
            let networkTask = base.get(with: category) { single($0) }
            
            return Disposables.create {
                networkTask.cancel()
            }
        }
    }
}
