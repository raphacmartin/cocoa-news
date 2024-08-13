import Foundation

final class EverythingService: NewsAPIService { }

// MARK: - Service methods
extension EverythingService {
    @discardableResult
    func search(with query: String, completion: @escaping (Result<NewsAPIResponse, Error>) -> Void) -> URLSessionTask {
        let endpoint = EverythingEndpoint(query: query)
        
        return makeRequest(to: endpoint, completion: completion)
    }
}
