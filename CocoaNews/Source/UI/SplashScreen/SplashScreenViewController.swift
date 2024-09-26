import AVKit
import RxRelay
import RxSwift
import UIKit

final class SplashScreenViewController: UIViewController {
    // MARK: Public properties
    public var didFinishLoading: Observable<Void> {
        didFinishLoadingRelay.asObservable()
    }
    
    // MARK: Private properties
    private var didFinishLoadingRelay = PublishRelay<Void>()
    
    // MARK: UI Components
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "splash_background")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildView()
        
        playVideo()
    }
}

// MARK: - View Code conformance
extension SplashScreenViewController: ViewCodeBuildable {
    func setupHierarchy() {
        view.addSubview(backgroundImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Video
extension SplashScreenViewController {
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "splash_video", ofType: "mp4") else {
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        player.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        didFinishLoadingRelay.accept(())
    }
}
