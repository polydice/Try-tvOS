//
//  DataFetching.swift
//  TryTVOS
//
//  Created by Ben on 30/10/2016.
//  Copyright © 2016 bcylin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Alamofire

protocol DataFetching: class {
  /// A reference to the pagination object that prevents duplicate requests.
  var pagination: Pagination { get }

  /// Performs request and parses the response as an array of T.
  ///
  /// - Parameters:
  ///   - request: An Alamofire URL request.
  ///   - sessionManager: A session manager to send the request. Optional, default is SessionManager.default.
  ///   - completion: A closure to be executed once the request has finished.
  func fetch<T: Decodable>(request: URLRequestConvertible, with sessionManager: SessionManager, completion: @escaping (Result<[T]>) -> Void)
}


extension DataFetching {

  func fetch<T: Decodable>(request: URLRequestConvertible, with sessionManager: SessionManager = SessionManager.default, completion: @escaping (Result<[T]>) -> Void) {
    guard pagination.isReady else {
      return
    }

    pagination.currentRequest = sessionManager.request(request).responseResult(queue: pagination.queue) { [weak self] result in
      switch result {
      case let .success(data):
        do {
          let decoder = JSONDecoder()
          let parsed = try decoder.decode(DataKeyPathDecoding<[T]>.self, from: data)
          let items = parsed.data
          self?.pagination.hasNextPage = parsed.links?.next != nil

          DispatchQueue.main.sync { completion(.success(items)) }
        } catch {
          DispatchQueue.main.sync { completion(.failure(error)) }
        }
      case let .failure(error):
        DispatchQueue.main.sync { completion(.failure(error)) }
      }
    }
  }

}


////////////////////////////////////////////////////////////////////////////////


class Pagination {

  fileprivate weak var currentRequest: Request?
  fileprivate var hasNextPage = true
  fileprivate let queue: DispatchQueue

  var isReady: Bool {
    return currentRequest == nil && hasNextPage
  }

  /// Returns an initialized pagination object.
  ///
  /// - Parameter name: The label of serial queue for pagination.
  init(name: String) {
    queue = DispatchQueue(label: name, attributes: [])
  }

}
