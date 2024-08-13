final class EverythingEndpoint {
    var query: String
    
    init(query: String) {
        self.query = query
    }
}

// MARK: Endpoint conformance
extension EverythingEndpoint: Endpoint {
    var path: String {
        "everything"
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var queryParameters: [String : String]? {
        ["q": query]
    }
}
