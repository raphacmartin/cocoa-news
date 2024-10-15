protocol Configuration {
    func retrieve(from key: ConfigurationKey) -> Bool
}

enum ConfigurationKey: String {
    case useSwiftUI
}
