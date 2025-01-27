protocol SessionStorage {
    func save(session: Session)
    func load() -> Session?
}

extension SessionStorage where Self == UserDefaultsSessionStorage {
    static var `default`: SessionStorage {
        UserDefaultsSessionStorage()
    }
}
