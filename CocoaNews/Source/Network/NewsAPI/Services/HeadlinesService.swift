import Foundation

final class HeadlinesService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}

// MARK: - Service methods
extension HeadlinesService {
    @discardableResult
    func get(with category: ArticleCategory, completion: @escaping (Result<Headlines, Error>) -> Void) -> URLSessionTask {
        let endpoint = HeadlinesEndpoint()
        endpoint.category = category
        
        return apiClient.request(from: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else {
                    completion(.failure(APIError.systemError("HeadlinesService is nil in the completion handler")))
                    return
                }
                
                guard let headlines = self.decodeHeadlines(from: data) else {
                    completion(.failure(APIError.invalidData))
                    return
                }
                
                completion(.success(headlines))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}

// MARK: - Private API
extension HeadlinesService {
    private func decodeHeadlines(from data: Data) -> Headlines? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let headlines = try? decoder.decode(Headlines.self, from: data) else {
            if let jsonData = String(data: data, encoding: .utf8) {
                print("Error decoding data to headlines: ")
                print(jsonData)
            }
            
            return nil
        }
        
        return headlines
    }
}
