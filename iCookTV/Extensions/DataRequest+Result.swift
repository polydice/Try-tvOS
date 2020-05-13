//
//  DataRequest+Result.swift
//  TryTVOS
//
//  Created by Ben on 11/15/16.
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

import Foundation
import Alamofire

enum Result<T> {
  case success(T)
  case failure(Error)

  func mapSuccess<U>(_ transform: (T) -> U) -> Result<U> {
    switch self {
    case .success(let value): return .success(transform(value))
    case .failure(let error): return .failure(error)
    }
  }

  func mapError(_ transform: (Error) -> Void) -> Result<T> {
    switch self {
    case .success: break
    case .failure(let error): transform(error)
    }
    return self
  }

}


////////////////////////////////////////////////////////////////////////////////


extension DataRequest {

  func responseResult(
    queue: DispatchQueue? = nil,
    options: JSONSerialization.ReadingOptions = .allowFragments,
    completion: @escaping (Result<Data>) -> Void
  ) -> Self {
    let serializer = DataRequest.jsonResponseSerializer(options: options)

    return response(queue: queue, responseSerializer: serializer) { response in
      guard let data = response.data else {
        let error = response.result.error ?? NSError(domain: "io.github.bcylin.try-tvos", code: NSURLErrorUnknown, userInfo: nil)
        completion(.failure(error))
        return
      }
      completion(.success(data))
    }
  }

}
