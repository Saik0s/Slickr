//
// Created by Igor Tarasenko on 18/10/2019.
// Licensed under the MIT license
//

import UIKit

enum PhotoCellState {
    case image(UIImage)
    case loading
}

protocol PhotoCellInput: AnyObject {
    func set(state: PhotoCellState)
}

final class PhotoCollectionViewCell: UICollectionViewCell, PhotoCellInput {
    static let reuseIdentifier = NSStringFromClass(PhotoCollectionViewCell.self)

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .white)
    private lazy var spinnerContainer: UIView = {
        let spinnerView = UIView(frame: .zero)
        spinnerView.backgroundColor = UIColor(red: 0.78, green: 0.93, blue: 0.93, alpha: 1.0)
        spinnerView.addSubview(activityIndicator)
        return spinnerView
    }()

    private var currentState: PhotoCellState = .loading

    var interactor: PhotoCellInteractor?

    override var bounds: CGRect {
        didSet {
            layout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        backgroundColor = UIColor(red: 0.96, green: 0.90, blue: 0.55, alpha: 1.0)

        set(state: currentState)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(state: PhotoCellState) {
        currentState = state

        switch currentState {
        case .loading:
            imageView.removeFromSuperview()
            if spinnerContainer.superview == nil {
                addSubview(spinnerContainer)
            }
            activityIndicator.startAnimating()
        case let .image(image):
            imageView.image = image
            imageView.alpha = 0
            addSubview(imageView)
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.alpha = 1
            }, completion: { _ in
                if case PhotoCellState.image = self.currentState {
                    self.spinnerContainer.removeFromSuperview()
                }
            })
        }

        layout()
    }

    private func layout() {
        switch currentState {
        case .loading:
            activityIndicator.startAnimating()
            spinnerContainer.frame = bounds
            activityIndicator.center = spinnerContainer.center
        case .image:
            imageView.frame = bounds
        }
    }
}
