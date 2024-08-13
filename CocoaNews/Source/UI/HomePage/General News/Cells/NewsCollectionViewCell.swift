import UIKit
import RxSwift

class NewsCollectionViewCell: UICollectionViewCell {
    // MARK: Private properties
    private var imageDownloadTask: Disposable? = nil
    
    // MARK: UI Components
    lazy var shadowView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        
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
    lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        return stackView
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
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    func configureCell(with article: Article) {
        buildView()
        
        imageView.showLoading()
        
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 3
        shadowView.layer.cornerRadius = 10
        mainStackView.layer.cornerRadius = 10
        mainStackView.layer.masksToBounds = true
        
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        
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
    }
}

// MARK: - View Code conformance
extension NewsCollectionViewCell: ViewCodeBuildable {
    func setupHierarchy() {
        [
            titleLabel,
            descriptionLabel
        ].forEach { textStackView.addArrangedSubview($0) }
        
        [
            imageView,
            textStackView
        ].forEach { mainStackView.addArrangedSubview($0) }
        
        shadowView.addSubview(mainStackView)
        
        addSubview(shadowView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
        ])
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
