import RxSwift
import UIKit

final class ImageDownloader {
    // MARK: Private properties
    // Use NSCache for thread safety and memory management
    private let cache = NSCache<NSString, UIImage>()
    private let queue = DispatchQueue(label: "com.coconews.imagedownloader.cache", attributes: .concurrent)
    
    // MARK: Singleton
    public static var shared = ImageDownloader()
    
    fileprivate init() {}
}

// MARK: Public API
extension ImageDownloader {
    public func downloadImage(from url: URL) -> Observable<UIImage> {
        Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(APIError.systemError("[ImageDownloader] Self deallocated"))
                return Disposables.create()
            }
            
            let cacheKey = url.absoluteString as NSString
            
            // Check cache first (thread-safe)
            if let cachedImage = self.cache.object(forKey: cacheKey) {
                print("[ImageDownloader] image returned from cache")
                observer.onNext(cachedImage)
                observer.onCompleted()
                return Disposables.create()
            }
            
            // Download image if not cached
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    observer.onError(APIError.systemError("[ImageDownloader] Invalid data"))
                    return
                }
                
                // Store in cache (thread-safe)
                self.cache.setObject(image, forKey: cacheKey)
                print("[ImageDownloader] image was downloaded and cached")
                observer.onNext(image)
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
