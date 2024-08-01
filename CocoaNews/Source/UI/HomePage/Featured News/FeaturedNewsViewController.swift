import UIKit

final class FeaturedNewsViewController: UIViewController {
    // MARK: Private properties
    private var articles = [Article]()
    
    // MARK: Private constants
    private let pageHorizontalPadding: CGFloat = 20
    private let pageVerticalPadding: CGFloat = 20
    
    // MARK: UI Components
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Featured News"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 24)
        label.textColor = UIColor(named: "SecondaryColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        buildView()
    }
}

// MARK: - Public API
extension FeaturedNewsViewController {
    public func set(articles: [Article]) {
        self.articles = articles
        self.collectionView.reloadData()
    }
}

// MARK: - View code conformance
extension FeaturedNewsViewController: ViewCodeBuildable {
    func setupHierarchy() {
        [
            titleContainerView,
            collectionView
        ].forEach { mainStackView.addArrangedSubview($0) }
        
        titleContainerView.addSubview(titleLabel)
        
        view.addSubview(mainStackView)
        
        collectionView.contentInset.left = pageHorizontalPadding
        collectionView.contentInset.right = pageHorizontalPadding
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: pageVerticalPadding),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: pageVerticalPadding),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleContainerView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: pageHorizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: -pageHorizontalPadding),
            
            collectionView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }
}

// MARK: - Private methods
extension FeaturedNewsViewController {
    private func setupCollectionView() {
        collectionView.register(FeaturedNewsCollectionViewCell.self, forCellWithReuseIdentifier: "reuseId")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension FeaturedNewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseId", for: indexPath) as? FeaturedNewsCollectionViewCell else {
            fatalError("Couldn't cast cell to `FeaturedNewsCollectionViewCell`")
        }
        
        let article = articles[indexPath.row]
        cell.configureCell(with: article)
        
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeaturedNewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 200, height: 200)
    }
}
