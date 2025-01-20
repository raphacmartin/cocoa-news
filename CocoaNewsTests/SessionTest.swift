import Testing
import Foundation

@testable import CocoaNews

struct SessionTest {
    static let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
    
    var validSession = Session(
        sessionStartedAtBuild: 1,
        sessionExp: nextYear,
        userData: [
            .favoriteCategories: [FavoriteCategory(id: "business", description: "Business")]
        ])
    
    @Test func validSessionIsValid() {
        let sessionManager = SessionManager(session: validSession, appMetadata: MockAppMetadataProvider())
        
        #expect(sessionManager.isSessionValid())
    }
    
    @Test func nilSessionIsInvalid() {
        let sessionManager = SessionManager(session: nil)
        
        #expect(sessionManager.isSessionValid() == false)
    }
    
    @Test func sessionStartedInPreviousBuildIsInvalid() {
        var session = validSession
        session.sessionStartedAtBuild = 0
        
        let sessionManager = SessionManager(session: session, appMetadata: MockAppMetadataProvider())
        
        #expect(sessionManager.isSessionValid() == false)
    }
    
    @Test func expiredSessionIsInvalid() {
        var session = validSession
        session.sessionExp = Date()
        
        let sessionManager = SessionManager(session: session, appMetadata: MockAppMetadataProvider())
        
        #expect(sessionManager.isSessionValid() == false)
    }
    
    @Test func sessionWithNoFavoriteCategoriesIsInvalid() {
        var session = validSession
        session.userData[.favoriteCategories] = nil
        
        let sessionManager = SessionManager(session: session, appMetadata: MockAppMetadataProvider())
        
        #expect(sessionManager.isSessionValid() == false)
    }
}

class MockAppMetadataProvider: AppMetadataProvider {
    var bundleVersion: Int { 1 }
}
