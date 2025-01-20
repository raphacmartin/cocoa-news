import Foundation

struct Session {
    typealias UserData = [UserDataKey: Any?]
    
    var sessionStartedAtBuild: Int
    var sessionExp: Date
    var userData: UserData
}
        
enum UserDataKey: String {
    case favoriteCategories = "favoriteCategories"
}
