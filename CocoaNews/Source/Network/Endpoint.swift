import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
    case PATCH
}

protocol Endpoint {
    var path: String { get }
    var headers: [String: String]? { get }
    var method: HTTPMethod { get }
    var bodyParameters: [String: Any?]? { get }
    var queryParameters: [String: String]? { get }
}

extension Endpoint {
    var headers: [String: String]? {
        nil
    }
    
    var bodyParameters: [String: Any?]? {
        nil
    }
    
    var queryParameters: [String: String]? {
        nil
    }
    
    var queryItems: [URLQueryItem] {
        guard let queryParameters = self.queryParameters else {
            return []
        }
        
        return queryParameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
    }
}
