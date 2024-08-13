import RxRelay
import RxSwift
import UIKit

final class HomePageViewController: UIViewController {
    // MARK: Private properties
    let viewModel: HomePageViewModel
    let layoutProvider: HomePageLayoutProvider
    let loadFeaturedNews = PublishRelay<Void>()
    let loadLatestNews = PublishRelay<Void>()
    let disposeBag = DisposeBag()
    
    // MARK: Initializer
    init(viewModel: HomePageViewModel, layoutProvider: HomePageLayoutProvider) {
        self.viewModel = viewModel
        self.layoutProvider = layoutProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("🔥")
    }
    
    // MARK: UI Components
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityLabel = "Header View"
        return view
    }()
    lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CocoaNews"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 60)
        label.textColor = .white
        
        return label
    }()
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 35
        stackView.accessibilityLabel = "Content Stack View"
        
        return stackView
    }()
    lazy var featuredNewsViewController: FeaturedNewsViewController = {
        let viewController = layoutProvider.getFeaturedNewsViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    lazy var generalNewsViewController: NewsListViewController = {
        let viewController = NewsListViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildView()
        
        setupSubscriptions()

        loadData()
    }
}

// MARK: - View Code conformance
extension HomePageViewController: ViewCodeBuildable {
    func setupHierarchy() {
        // Setting up the header
        headerView.addSubview(headerTitleLabel)
        
        // Setting up the content
        [
            featuredNewsViewController.view,
            generalNewsViewController.view
        ].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        // Adding the header and the content to the main stack view
        [
            headerView,
            contentStackView
        ].forEach { mainStackView.addArrangedSubview($0) }
        
        // Adding the main stack view to the ViewController's view
        view.addSubview(mainStackView)
        
        // Making the sub-viewcontrollers children of this VC
        addChild(featuredNewsViewController)
        addChild(generalNewsViewController)
        featuredNewsViewController.didMove(toParent: self)
        generalNewsViewController.didMove(toParent: self)
        
        // Styling
        view.backgroundColor = UIColor(named: "AccentColor")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            headerTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            featuredNewsViewController.view.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    
}

// MARK: - Private methods
extension HomePageViewController {
    private func setupSubscriptions() {
        let input = HomePageViewModel.Input(
            loadFeaturedNews: loadFeaturedNews.asObservable(),
            loadLatestNews: loadLatestNews.asObservable()
        )
        
        let output = viewModel.connect(input: input)
        
        output.featuredNews
            .subscribe(onNext: { [weak self] headlines in
                self?.featuredNewsViewController.set(articles: headlines.articles)
            })
            .disposed(by: disposeBag)
        
        output.latestNews
            .subscribe(onNext: { [weak self] headlines in
                self?.generalNewsViewController.set(articles: headlines.articles)
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        loadFeaturedNews.accept(())
        loadLatestNews.accept(())
    }
}
