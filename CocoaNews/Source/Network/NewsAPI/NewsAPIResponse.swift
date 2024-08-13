struct NewsAPIResponse: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}
