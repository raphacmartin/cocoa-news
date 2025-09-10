import RxSwift
import UIKit

final class ImageDownloader {
    // MARK: - Properties

    // Use NSCache for better memory management and thread safety
    private let imageCache = NSCache<NSString, UIImage>()

    // Singleton instance
    static let shared = ImageDownloader()
    private init() {}
}

// MARK: - Public API
extension ImageDownloader {
    /// Downloads an image from the given URL, using an in-memory cache.
    /// - Parameter url: The image URL.
    /// - Returns: An observable that emits the UIImage.
    public func downloadImage(from url: URL) -> Observable<UIImage> {
        Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(APIError.systemError("[ImageDownloader] Self deallocated"))
                return Disposables.create()
            }

            let cacheKey = url.absoluteString as NSString

            // Check cache synchronously
            if let cachedImage = self.imageCache.object(forKey: cacheKey) {
                print("[ImageDownloader] image returned from cache")
                observer.onNext(cachedImage)
                observer.onCompleted()
                return Disposables.create()
            }

            // Not in cache, download
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    observer.onError(APIError.systemError("[ImageDownloader] Invalid image data"))
                    return
                }

                // Store in cache
                self.imageCache.setObject(image, forKey: cacheKey)
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
