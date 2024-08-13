import UIKit

final class NewsListViewController: UIViewController {
    // MARK: Private properties
    var articles = [Article]()
    
    // MARK: UI Components
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        
        return stackView
    }()
    
    lazy var titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Latest News"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 24)
        label.textColor = UIColor(named: "SecondaryColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
            heightDimension: NSCollectionLayoutDimension.estimated(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets.leading = StyleGuide.pageVerticalPadding
        item.contentInsets.trailing = StyleGuide.pageVerticalPadding
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, repeatingSubitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
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
extension NewsListViewController {
    public func set(articles: [Article]) {
        self.articles = articles
        self.collectionView.reloadData()
    }
}

// MARK: - View code conformance
extension NewsListViewController: ViewCodeBuildable {
    func setupHierarchy() {
        [
            titleContainerView,
            collectionView
        ].forEach { mainStackView.addArrangedSubview($0) }
        
        titleContainerView.addSubview(titleLabel)
        
        view.addSubview(mainStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: StyleGuide.pageVerticalPadding),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: StyleGuide.pageVerticalPadding),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleContainerView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: StyleGuide.pageHorizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: -StyleGuide.pageHorizontalPadding),
            
            collectionView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
    }
    
    
}

// MARK: - Private methods
extension NewsListViewController {
    private func setupCollectionView() {
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: "reuseId")
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension NewsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseId", for: indexPath) as? NewsCollectionViewCell else {
            fatalError("Couldn't cast cell to `NewsCollectionViewCell`")
        }
        
        let article = articles[indexPath.row]
        cell.configureCell(with: article)
        
        return cell
    }
}

extension NewsListViewController  {
    
}
