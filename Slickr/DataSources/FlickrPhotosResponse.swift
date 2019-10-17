//
// Created by Igor Tarasenko on 15/10/2019.
// Licensed under the MIT license
//

// MARK: - FlickrPhotosResponse
struct FlickrPhotosResponse: Codable {
    let photos: Photos
}

// MARK: - Photos
struct Photos: Codable {
    let page: Int
    let pages: String
    let perpage: Int
    let total: String
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
}
