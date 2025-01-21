import Testing
import Foundation

@testable import CocoaNews

struct SessionTest {
    var validSession: Session
    
    init() {
        let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        
        let userData = UserData()
        try? userData.set(key: .favoriteCategories, value: [FavoriteCategory(id: "business", description: "Business")])
        
        self.validSession = Session(
           sessionStartedAtBuild: 1,
           sessionExp: nextYear,
           userData: userData)
    }
    
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
    
    @Test func sessionWithNoFavoriteCategoriesIsInvalid() throws {
        let session = validSession
        try session.userData.set(key: .favoriteCategories, value: nil)
        
        let sessionManager = SessionManager(session: session, appMetadata: MockAppMetadataProvider())
        
        #expect(sessionManager.isSessionValid() == false)
    }
}

class MockAppMetadataProvider: AppMetadataProvider {
    var bundleVersion: Int { 1 }
}
