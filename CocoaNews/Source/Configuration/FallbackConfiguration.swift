import RxSwift

/// `Configuration` implementation with default values to be used when the real service is unreachable.
public final class FallbackConfiguration { }

// MARK: - Configuration conformance
extension FallbackConfiguration: Configuration {
    func retrieve(from key: ConfigurationKey) -> Bool {
        switch key {
        case .useSwiftUI: false
        }
    }
}
