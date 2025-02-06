import Foundation

struct Session: Codable {
    var sessionStartedAtBuild: Int
    var sessionExp: Date
    var userData: UserData
}
        
enum UserDataKey: String, Codable {
    case favoriteCategories = "favoriteCategories"
}

class UserData: Codable {
    private var dict = [String: Data]()
    
    func set(key: UserDataKey, value: Encodable?) throws {
        guard let value = value else {
            dict[key.rawValue] = nil
            return
        }
        dict[key.rawValue] = try JSONEncoder().encode(value)
    }
    
    func read<T: Decodable>(from key: UserDataKey, as type: T.Type) -> T? {
        if let data = dict[key.rawValue] {
            return try? JSONDecoder().decode(type, from: data)
        }
        return nil
    }
}
