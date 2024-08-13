import UIKit
import RxSwift

final class FeaturedNewsCollectionViewCell: UICollectionViewCell {
    // MARK: Private properties
    private var imageDownloadTask: Disposable? = nil
    
    // MARK: UI Components
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    lazy var imageView: LoadableImageView = {
        let imageView = LoadableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "circle.dashed")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title Of The Article"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 18)
        label.numberOfLines = 2
        return label
    }()
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque a egestas tortor. Proin interdum vestibulum accumsan. Curabitur tristique pellentesque tincidunt. "
        label.font = UIFont(name: "ArialMT", size: 12)
        label.numberOfLines = 2
        return label
    }()
    
    func configureCell(with article: Article) {
        buildView()
        
        titleLabel.text = article.title
        descriptionLabel.text = article.title
        imageView.showLoading()
        
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            imageDownloadTask = ImageDownloader.shared.downloadImage(from: url)
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] image in
                    self?.imageView.setImage(image)
                }, onError: { [weak self] _ in
                    self?.imageView.showFallbackImage()
                })
        } else {
            imageView.showFallbackImage()
        }
        
        backgroundColor = .white
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = Float(StyleGuide.FeaturedNews.cardShadowOpacity)
        layer.shadowOffset = .zero
        layer.shadowRadius = StyleGuide.FeaturedNews.cardShadowRadius
        layer.cornerRadius = StyleGuide.FeaturedNews.cardCornerRadius
        mainStackView.layer.cornerRadius = 10
        mainStackView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        imageView.showLoading()
        imageDownloadTask?.dispose()
    }
}

// MARK: - View Code conformance
extension FeaturedNewsCollectionViewCell: ViewCodeBuildable {
    func setupHierarchy() {
        [
            imageView,
            titleLabel,
            descriptionLabel
        ].forEach { mainStackView.addArrangedSubview($0) }
        
        addSubview(mainStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: StyleGuide.FeaturedNews.imageHeight)
        ])
    }
}
