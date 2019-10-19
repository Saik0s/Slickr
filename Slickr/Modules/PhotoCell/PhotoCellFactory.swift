//
// Created by Igor Tarasenko on 18/10/2019.
// Licensed under the MIT license
//

protocol PhotoCellFactory {
    func configureCell(_ cell: PhotoCollectionViewCell?) -> PhotoCollectionViewCell
}

final class DefaultPhotoCellFactory: PhotoCellFactory {
    private let imageService: ImageService

    init(imageService: ImageService) {
        self.imageService = imageService
    }

    func configureCell(_ cell: PhotoCollectionViewCell?) -> PhotoCollectionViewCell {
        let cell = cell ?? PhotoCollectionViewCell(frame: .zero)

        // Check if we need to create a new interactor
        guard cell.interactor == nil else { return cell }

        let presenter = DefaultPhotoCellPresenter()
        let interactor = DefaultPhotoCellInteractor(imageService: imageService, presenter: presenter)
        presenter.view = cell
        cell.interactor = interactor

        return cell
    }
}


