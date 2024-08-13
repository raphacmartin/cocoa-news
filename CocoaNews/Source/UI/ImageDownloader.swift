import RxSwift
import UIKit

final class ImageDownloader {
    // MARK: Private properties
    private var cachedImages = [String: UIImage]()
    
    // MARK: Singleton
    public static var shared = ImageDownloader()
    
    fileprivate init() {}
}

// MARK: Public API
extension ImageDownloader {
    public func downloadImage(from url: URL) -> Observable<UIImage> {
        Observable.create { [weak self] observer in
            var ongoingTask: URLSessionTask? = nil
            
            if let cachedImage = self?.cachedImages[url.absoluteString] {
                print("[ImageDownloader] image returned from cache")
                observer.onNext(cachedImage)
            } else {
                ongoingTask = URLSession.shared.dataTask(with: url, completionHandler: { data, urlResponse, error in
                    guard let data = data, error == nil else {
                        observer.onError(error ?? APIError.systemError("[ImageDownloader] Error downloading image"))
                        return
                    }
                    
                    guard let image = UIImage(data: data) else {
                        observer.onError(APIError.systemError("[ImageDownloader] Invalid data"))
                        return
                    }
                    
                    print("[ImageDownloader] image was downloaded")
                    self?.cachedImages[url.absoluteString] = image
                    observer.onNext(image)
                })
                
                ongoingTask?.resume()
            }
            
            return Disposables.create {
                ongoingTask?.cancel()
            }
        }
    }
}
