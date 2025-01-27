import Foundation

final class UserDefaultsSessionStorage {
    let defaults = UserDefaults.standard
    let sessionKey = "session"
}

extension UserDefaultsSessionStorage: SessionStorage {
    func save(session: Session) {
        defaults.set(try? JSONEncoder().encode(session), forKey: sessionKey)
    }
    
    func load() -> Session? {
        guard let data = defaults.data(forKey: sessionKey) else {
            return nil
        }
        
        return try? JSONDecoder().decode(Session.self, from: data)
    }
}
