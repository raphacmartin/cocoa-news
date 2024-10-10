import RxRelay
import RxSwift
import UnleashProxyClientSwift

final class UnleashConfiguration {
    // MARK: Public properties
    public var isReady: Observable<Void> {
        isReadyRelay.asObservable()
    }
    
    // MARK: Private properties
    private let isReadyRelay = PublishRelay<Void>()
    private let unleashClient: UnleashClient
    
    // MARK: Initializer
    init() {
        let unleashUrl = ProcessInfo.processInfo.environment["UNLEASH_URL"] ?? ""
        let clientKey = ProcessInfo.processInfo.environment["UNLEASH_CLIENT_KEY"] ?? ""
        
        self.unleashClient = UnleashClient(
            unleashUrl: unleashUrl,
            clientKey: clientKey
        )
        
        unleashClient.start()
        
        unleashClient.subscribe(name: "ready") { [weak self] in
            guard let self = self else { return }
            
            self.isReadyRelay.accept(())
        }
        
        // FIXME: implement error handling: https://github.com/raphacmartin/cocoa-news/issues/14
    }
}

// MARK: - Configuration conformance
extension UnleashConfiguration: Configuration {
    func retrieve(from key: ConfigurationKey) -> Bool {
        unleashClient.isEnabled(name: key.rawValue)
    }
}
