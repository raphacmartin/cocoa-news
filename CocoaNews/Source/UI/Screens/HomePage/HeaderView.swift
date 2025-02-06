import UIKit

final class HeaderView: UIView {}

// MARK: Gradient
extension HeaderView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + StyleGuide.contentViewRadius)
        gradientLayer.colors = [UIColor.accent.cgColor, UIColor.secondary.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.75, y: 1.75)
        
        layer.insertSublayer(gradientLayer, below: layer.sublayers?.first)
    }
}
