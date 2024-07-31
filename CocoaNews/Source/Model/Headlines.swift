struct Headlines: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}
