//
// Created by Igor Tarasenko on 20/10/2019.
// Licensed under the MIT license
//

import struct Foundation.Data
@testable import Slickr

final class MockedImageService: ImageService {

    var invokedLoadImage = false
    var invokedLoadImageCount = 0
    var invokedLoadImageParameters: (photoInfo: PhotoInfo, Void)?
    var invokedLoadImageParametersList = [(photoInfo: PhotoInfo, Void)]()
    var stubbedLoadImageCompletionResult: (Result<Data, Error>, Void)?
    var stubbedLoadImageResult: Cancelable!

    func loadImage(for photoInfo: PhotoInfo, completion: @escaping (Result<Data, Error>) -> Void) -> Cancelable? {
        invokedLoadImage = true
        invokedLoadImageCount += 1
        invokedLoadImageParameters = (photoInfo, ())
        invokedLoadImageParametersList.append((photoInfo, ()))
        if let result = stubbedLoadImageCompletionResult {
            completion(result.0)
        }
        return stubbedLoadImageResult
    }
}