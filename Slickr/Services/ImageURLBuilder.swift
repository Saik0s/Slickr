//
// Created by Igor Tarasenko on 17/10/2019.
// Licensed under the MIT license
//

import Foundation

protocol ImageURLBuilder: AnyObject {
    func url(for flickrPhotoInfo: FlickrPhotoInfo) -> URL?
}

final class DefaultImageURLBuilder: ImageURLBuilder {
    /// Creates url with this format:
    /// https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
    func url(for flickrPhotoInfo: FlickrPhotoInfo) -> URL? {
        let farmID = flickrPhotoInfo.farm
        let serverID = flickrPhotoInfo.server
        let id = flickrPhotoInfo.id
        let secret = flickrPhotoInfo.secret

        let urlString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg"
        return URL(string: urlString)
    }
}
