final class HeadlinesEndpoint {
    var category: ArticleCategory? = nil
    var sources: String? = nil
    var q: String? = nil
    var pageSize: Int? = nil
    var page: Int? = nil
}

// MARK: Endpoint conformance
extension HeadlinesEndpoint: Endpoint {
    var path: String {
        "top-headlines"
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var queryParameters: [String : String]? {
        // Always send the country as US
        var params = ["country": "us"]

        if let category = category {
            params["category"] = category.rawValue
        }
        
        return params
    }
}
