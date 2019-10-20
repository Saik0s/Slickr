//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

import Foundation

protocol ImageService: AnyObject {
    @discardableResult
    func loadImage(for photoInfo: PhotoInfo, completion: @escaping (Result<Data, Error>) -> Void) -> Cancelable?
}

final class DefaultImageService: ImageService {
    enum Error: Swift.Error {
        case noData
    }

    private let imageCache = NSCache<AnyObject, AnyObject>()
    private let cacheQueue = DispatchQueue(label: "Cache")

    private let networkEngine: NetworkEngine

    init(networkEngine: NetworkEngine) {
        self.networkEngine = networkEngine
    }

    @discardableResult
    func loadImage(for photoInfo: PhotoInfo, completion: @escaping (Result<Data, Swift.Error>) -> Void) -> Cancelable? {
        // Try to get cached first
        if let data = imageCache.object(forKey: photoInfo.url as AnyObject) as? Data {
            completion(.success(data))
            return nil
        }

        // Perform request in other case
        let requestInfo = RequestInfo(url: photoInfo.url, parameters: [:])

        return networkEngine.get(with: requestInfo) { [weak self] result in
            switch result {
            case let .success(data):
                // Return failure if no data
                guard let data = data else {
                    completion(.failure(Error.noData))
                    return
                }

                // Save to cache
                self?.cacheQueue.async {
                    self?.imageCache.setObject(data as AnyObject, forKey: photoInfo.url as AnyObject)
                }

                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
