//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

import UIKit

protocol SearchScreenViewInput: AnyObject {
    func new(items: [PhotoInfo])
    func add(items: [PhotoInfo])
}

final class SearchScreenViewController: UIViewController, SearchScreenViewInput {
    private let spacing: CGFloat = 10.0
    private let numberOfItemsInRow = 3
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let interactor: SearchScreenInteractor
    private let dataSource: SearchScreenDataSource

    init(interactor: SearchScreenInteractor, dataSource: SearchScreenDataSource) {
        self.interactor = interactor
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupSearchController()

        refreshControl.beginRefreshing()
        interactor.reload()
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        dataSource.register(collectionView: collectionView)
        collectionView.delegate = self

        collectionView.keyboardDismissMode = .interactive

        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCollection), for: .valueChanged)
        refreshControl.tintColor = UIColor(red: 0.49, green: 0.84, blue: 0.87, alpha: 1.0)
    }

    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchController.searchBar
            searchController.hidesNavigationBarDuringPresentation = false
        }
        definesPresentationContext = true
    }

    @objc private func refreshCollection(_ sender: Any) {
        interactor.reload()
    }

    // MARK: - SearchScreenViewInput

    func new(items: [PhotoInfo]) {
        dataSource.set(items: items)
        refreshControl.endRefreshing()
    }

    func add(items: [PhotoInfo]) {
        dataSource.append(items: items)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }

        let collectionViewWidth = self.collectionView.bounds.width

        let extraSpace = CGFloat(numberOfItemsInRow - 1) * flowLayout.minimumInteritemSpacing

        let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left

        let width = Int((collectionViewWidth - extraSpace - inset) / CGFloat(numberOfItemsInRow))

        return CGSize(width: width, height: width)
    }
}

// MARK: - UICollectionViewDelegate

extension SearchScreenViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard dataSource.count > 0 else { return }

        if indexPath.row == dataSource.count - 10 {
            interactor.loadNextPage()
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchScreenViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        interactor.search(for: searchController.searchBar.text ?? "")
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        interactor.search(for: "")
    }
}