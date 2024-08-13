import Foundation

class NewsAPIService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}

// MARK: - Public API
extension NewsAPIService {
    func makeRequest(to endpoint: Endpoint, completion: @escaping (Result<NewsAPIResponse, Error>) -> Void) -> URLSessionTask {
        
        return apiClient.request(from: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else {
                    completion(.failure(APIError.systemError("HeadlinesService is nil in the completion handler")))
                    return
                }
                
                guard let headlines = self.decodeResponse(from: data) else {
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
extension NewsAPIService {
    private func decodeResponse(from data: Data) -> NewsAPIResponse? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let headlines = try? decoder.decode(NewsAPIResponse.self, from: data) else {
            if let jsonData = String(data: data, encoding: .utf8) {
                print("Error decoding data to headlines: ")
                print(jsonData)
            }
            
            return nil
        }
        
        return headlines
    }
}
