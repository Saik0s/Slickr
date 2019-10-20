<h1 align="center">
  <br>
  Slickr
  <br>
</h1>

<h4 align="center">A simple ios gallery app using Flickr API </h4>

<p align="center">
  <a href="#description">Description</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#to-do-next">To Do Next</a> •
  <a href="#license">License</a>
</p>

## Description

This is a simple app that can perform search requests to Flickr API and display result in a collection view. 
Architecture of this app is service based with [VIP](https://clean-swift.com/) design pattern. Most important parts of the application are covered 
with Unit tests and overall implementation follows [SOLID](https://www.wikiwand.com/en/SOLID) principles.

There are two modules: `SearchScreen` and `PhotoCell`. 
Each module has its own factory. Main components of the module are `Interactor`, `Presenter` and `View`.
Interactors communicate with Services. There are two services: `FeedService` which is responsible for performing search requests 
and getting recent photos, and `ImageService` which is responsible for requesting and caching images.

`FeedService` uses `FlickrDataSource` to communicate with the Flickr API. It is also uses `ImageURLBuilder` to build image url from the api response.

`ImageService` performs requests through `NetworkEngine` to get image data. It also caches data.

`NetworkEngine` is a simple wrapper around `URLSessionDataTask` to perform get and post requests. 

## How To Use

This project is using Swift 5.1 so it requires Xcode >= 11

Just clone this repository and open `Slickr.xcodeproj`

## To Do next

- Add more tests(datasource, views, factories)
- Check callbacks in interactors that response is for the latest request
- Download thumbnails instead of original images to display in collection
- Open image in zoomable view controller

## License

MIT
