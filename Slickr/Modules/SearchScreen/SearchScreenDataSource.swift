//
// Created by Igor Tarasenko on 18/10/2019.
// Licensed under the MIT license
//

import UIKit

protocol SearchScreenDataSource: AnyObject, UICollectionViewDataSource {
    var count: Int { get }

    func register(collectionView: UICollectionView)
    func set(items: [PhotoInfo])
    func append(items: [PhotoInfo])
}

final class DefaultSearchScreenDataSource: NSObject, SearchScreenDataSource {
    private var items: [PhotoInfo] = []
    private var collectionView: UICollectionView?

    private let photoCellFactory: PhotoCellFactory

    init(photoCellFactory: PhotoCellFactory) {
        self.photoCellFactory = photoCellFactory
        super.init()
    }

    // MARK: - searchScreenDataSource
    var count: Int { items.count }

    func register(collectionView: UICollectionView) {
        self.collectionView = collectionView

        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
    }

    func set(items: [PhotoInfo]) {
        print("\(type(of: self)).\(#function)")

        self.items = items

        collectionView?.reloadData()
    }

    func append(items: [PhotoInfo]) {
        print("\(type(of: self)).\(#function)")
        let newIndexPaths = items.enumerated().map { index, _ in IndexPath(item: index + self.count, section: 0) }
        self.items.append(contentsOf: items)

        collectionView?.insertItems(at: newIndexPaths)
    }

    // MARK: - UICollectionViewDataSource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = PhotoCollectionViewCell.reuseIdentifier
        let reusedCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoCollectionViewCell
        let cell = photoCellFactory.configureCell(reusedCell)
        let currentItem = items[indexPath.row]
        cell.interactor?.configure(with: currentItem)
        return cell
    }
}
