//
// Created by Igor Tarasenko on 18/10/2019.
// Licensed under the MIT license
//

protocol PhotoCellInteractor: AnyObject {
    func configure(with photoInfo: PhotoInfo)
}

final class DefaultPhotoCellInteractor: PhotoCellInteractor {
    private var currentPhotoInfo: PhotoInfo?
    private var currentTask: Cancelable?
    private let imageService: ImageService
    private let presenter: PhotoCellPresenter

    init(imageService: ImageService, presenter: PhotoCellPresenter) {
        self.imageService = imageService
        self.presenter = presenter
    }

    func configure(with photoInfo: PhotoInfo) {
        presenter.setLoading()
        currentPhotoInfo = photoInfo

        // Cancel previous task
        currentTask?.cancel()

        // Request a new image from image service
        currentTask = imageService.loadImage(for: photoInfo) { [weak self] result in
            self?.currentTask = nil

            switch result {
            case let .success(data):
                self?.presenter.presentImage(with: data)
            case let .failure(error):
                print("\(#function) error: \(error)")
            }
        }
    }
}
