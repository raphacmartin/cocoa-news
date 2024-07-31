import Foundation

enum APIError: LocalizedError {
    case invalidData
    case networkError(Error)
    case systemError(String)
    case httpError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid data"
        case .systemError(let msg):
            return msg
        case .httpError(let code):
            return "Http Response Code: \(code)"
        default:
            return self.localizedDescription
        }
    }
}

protocol APIClient {
    var baseURL: URL { get }
    var apiKey: String { get }
    
    func request(from endpoint: Endpoint, completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionTask
}
