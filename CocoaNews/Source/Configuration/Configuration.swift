import RxSwift

protocol Configuration {
    var isReady: Observable<Void> { get }
    
    func retrieve(from key: ConfigurationKey) -> Bool
}

enum ConfigurationKey: String {
    case useSwiftUI
}
