import RxSwift

/// Object responsible for starting the configuration suite
public enum ConfigurationManager {
    /// Starts the configuration process by creating an observable that emits a `Configuration` object.
    ///
    /// The method uses RxSwift to observe the readiness state and error events of an `UnleashConfiguration` instance, providing the observer with either a successful `UnleashConfiguration` or a fallback configuration in case of an error.
    ///
    /// - Returns:
    ///   An `Observable` of `Configuration` that emits either:
    ///   - A `UnleashConfiguration` when it is ready.
    ///   - A `FallbackConfiguration` in case of an error.
    ///
    /// The observable performs the following:
    /// - Emits the `UnleashConfiguration` instance when it is ready.
    /// - Emits a `FallbackConfiguration` if an error occurs while starting `UnleashConfiguration`.
    /// - Disposes resources when the observable is terminated.
    ///
    /// ## Example
    /// ```swift
    /// ConfigurationManager.start()
    ///     .subscribe(onNext: { configuration in
    ///         // Handle configuration
    ///     })
    ///     .disposed(by: disposeBag)
    /// ```
    ///
    /// - Important: The method is designed to manage asynchronous configuration handling via RxSwift observables.
    static func start() -> Single<Configuration> {
        var disposeBag: DisposeBag? = DisposeBag()
        
        return Single.create { single in
            if let disposeBag = disposeBag {
                let unleashConfiguration = UnleashConfiguration()
                
                unleashConfiguration.isReady
                    .map { unleashConfiguration }
                    .subscribe(onNext: { configuration in
                        single(.success(configuration))
                    }, onError: { error in
                        print("[ConfigurationManager] error starting unleash: \(error)")
                        single(.success(FallbackConfiguration()))
                    })
                    .disposed(by: disposeBag)
            }
                
            return Disposables.create {
                disposeBag = nil
            }
        }
    }
}
