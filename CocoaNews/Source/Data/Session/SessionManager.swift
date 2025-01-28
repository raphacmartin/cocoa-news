import Foundation

final class SessionManager {
    // MARK: - Singleton
    static let shared = SessionManager()
    
    // MARK: - Constants
    private let thirtyDays: TimeInterval = 60 * 60 * 24 * 30
    private let storage: SessionStorage = .default
    
    // MARK: - Private Properties
    private var session: Session? = nil
    private var appMetadata: AppMetadataProvider
    
    // MARK: - Initializer
    init(session: Session? = nil, appMetadata: AppMetadataProvider = DefaultAppMetadata()) {
        self.session = session ?? storage.load()
        self.appMetadata = appMetadata
    }
}

// MARK: - Public API
extension SessionManager {
    func startSession() {
        let session = Session(
            sessionStartedAtBuild: appMetadata.bundleVersion,
            sessionExp: Date().addingTimeInterval(thirtyDays),
            userData: UserData()
        )
        
        self.session = session
        
        storage.save(session: session)
    }
    
    func isSessionValid() -> Bool {
        guard let session else { return false }
        
        let rules = [
            session.started(inBuild: appMetadata.bundleVersion),
            !session.isExpired(),
            session.hasFavorites()
        ]
        
        return rules.allSatisfy(\.self)
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
        guard let favorites = userData.read(from: .favoriteCategories, as: [ArticleCategory].self) else { return false }
        return !favorites.isEmpty
    }
}
