//
// Created by Igor Tarasenko on 15/10/2019.
// Licensed under the MIT license
//

// MARK: - FlickrPhotosResponse
struct FlickrPhotosResponse: Codable {
    let photos: FlickrPhotos
}

// MARK: - FlickrPhotos
struct FlickrPhotos: Codable {
    let page: UInt
    let pages: UInt
    let perpage: UInt
    let total: UInt
    let photo: [FlickrPhotoInfo]
}

// MARK: - FlickrPhotoInfo
struct FlickrPhotoInfo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
}
