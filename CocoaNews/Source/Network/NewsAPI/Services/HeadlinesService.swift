import Foundation

final class HeadlinesService: NewsAPIService { }

// MARK: - Service methods
extension HeadlinesService {
    @discardableResult
    func get(with category: ArticleCategory, completion: @escaping (Result<NewsAPIResponse, Error>) -> Void) -> URLSessionTask {
        let endpoint = HeadlinesEndpoint()
        endpoint.category = category

        return makeRequest(to: endpoint, completion: completion)
    }
}
