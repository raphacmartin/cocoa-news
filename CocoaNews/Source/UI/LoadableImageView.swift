import UIKit

class LoadableImageView: UIImageView {
    // MARK: Public methods
    public func showLoading() {
        image = UIImage(systemName: "circle.dashed")
        contentMode = .scaleAspectFit
        startAnimation()
    }
    
    public func setImage(_ image: UIImage) {
        self.image = image
        contentMode = .scaleAspectFill
        layer.removeAllAnimations()
    }
    
    public func showFallbackImage() {
        image = UIImage(systemName: "newspaper")
        contentMode = .scaleAspectFit
        layer.removeAllAnimations()
    }
    
    // MARK: Private methods
    private func startAnimation() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(rotation, forKey: "rotationAnimation")
    }
}
