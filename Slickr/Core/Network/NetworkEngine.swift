//
// Created by Igor Tarasenko on 14/10/2019.
// Licensed under the MIT license
//

import Foundation

enum NetworkError: Error {
    case cantCreateRequest
    case cantConstructURL
    case cantSetBody(Error)
    case badStatusCode(Int)
    case unknown
}

/// Interface for performing HTTP requests
protocol NetworkEngine: AnyObject {
    typealias ResponseHandler = (Result<Data?, Error>) -> Void

    // Perform Get Request
    @discardableResult
    func get(with info: RequestInfo, completion: @escaping ResponseHandler) -> Cancelable?

    // Perform Post Request with body as a JSON
    @discardableResult
    func post(with info: RequestInfo, completion: @escaping ResponseHandler) -> Cancelable?
}

final class DefaultNetworkEngine: NetworkEngine {
    private enum HTTPMethod: String {
        case GET, POST
    }

    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(with info: RequestInfo, completion: @escaping ResponseHandler) -> Cancelable? {
        return performRequest(with: info, method: .GET, completion: completion)
    }

    func post(with info: RequestInfo, completion: @escaping ResponseHandler) -> Cancelable? {
        return performRequest(with: info, method: .POST, completion: completion)
    }

    private func performRequest(with info: RequestInfo, method: HTTPMethod, completion: @escaping ResponseHandler) -> Cancelable? {
        do {
            let request = try createRequest(with: info, method: method)
            print("Request: \(request)")
            let task = session.dataTask(with: request) { data, response, error in
                // Check fo error
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {
                    print("Error: \(String(describing: error))")
                    completion(.failure(error ?? NetworkError.unknown))
                    return
                }

                print("Response: \(response)")

                // Check status code
                guard (200 ... 299) ~= response.statusCode else {
                    completion(.failure(NetworkError.badStatusCode(response.statusCode)))
                    return
                }

                completion(.success(data))
            }

            task.resume()
            return task
        } catch {
            completion(.failure(error))
            return nil
        }
    }

    private func createRequest(with info: RequestInfo, method: HTTPMethod) throws -> URLRequest {
        switch method {
        case .GET:
            var components = URLComponents(url: info.url, resolvingAgainstBaseURL: false)

            if !info.parameters.isEmpty {
                components?.queryItems = info.parameters.map { (key, value) in
                    URLQueryItem(name: key, value: "\(value)")
                }
            }

            guard let newURL = components?.url else {
                throw NetworkError.cantConstructURL
            }

            var request = URLRequest(url: newURL)
            request.httpMethod = method.rawValue

            return request

        case .POST:
            var request = URLRequest(url: info.url)
            request.httpMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: info.parameters, options: .prettyPrinted)
            } catch {
                throw NetworkError.cantSetBody(error)
            }

            return request
        }
    }
}
