import Foundation

final class NewsAPIClient: APIClient {
    var baseURL: URL {
        URL(string: ProcessInfo.processInfo.environment["NEWS_API_URL"] ?? "")!
    }
    
    var apiKey: String {
        ProcessInfo.processInfo.environment["NEWS_API_KEY"] ?? ""
    }
    
    func request(from endpoint: Endpoint, completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionTask {
        var url = baseURL
        url.appendPathComponent(endpoint.path)
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            if urlComponents.queryItems == nil {
                urlComponents.queryItems = [URLQueryItem]()
            }
            
            urlComponents.queryItems?.append(contentsOf: endpoint.queryItems)
            urlComponents.queryItems?.append(URLQueryItem(name: "apiKey", value: apiKey))
            
            if let newUrl = urlComponents.url {
                url = newUrl
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        endpoint.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let parameters = endpoint.bodyParameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.systemError("Response is not a HTTPURLResponse")))
                return
            }
            
            guard 200..<299 ~= httpResponse.statusCode else {
                // TODO: Decode body response
                completion(.failure(.httpError(httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(data))
        }

        task.resume()

        return task
    }
    
    
}
