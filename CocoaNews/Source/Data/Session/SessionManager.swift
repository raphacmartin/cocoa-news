import Foundation

final class SessionManager {
    // MARK: - Singleton
    static let shared = SessionManager()
    
    // MARK: - Private Properties
    private var session: Session?
    private var appMetadata: AppMetadataProvider
    
    // MARK: - Initializer
    init(session: Session? = nil, appMetadata: AppMetadataProvider = DefaultAppMetadata()) {
        self.session = session
        self.appMetadata = appMetadata
    }
}

// MARK: - Public API
extension SessionManager {
    func isSessionValid() -> Bool {
        guard let session else { return false }
        
        let rules = [
            session.started(inBuild: appMetadata.bundleVersion),
            !session.isExpired(),
            session.hasFavorites()
        ]
        
        return rules.allSatisfy(\.self)
    }
    
    func getUserData() -> Session.UserData? {
        session?.userData
    }
    
    func setUserData(key: UserDataKey, value: Any) {
        session?.userData[key] = value
    }
}

// MARK: - Validation Rules
extension Session {
    func started(inBuild build: Int) -> Bool {
        return sessionStartedAtBuild == build
    }
    
    func isExpired() -> Bool {
        let now = Date()
        return now > sessionExp
    }
    
    func hasFavorites() -> Bool {
        guard let favorites = userData[.favoriteCategories] as? [String] else { return false }
        return !favorites.isEmpty
    }
}
