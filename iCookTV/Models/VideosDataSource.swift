//
//  VideosDataSource.swift
//  TryTVOS
//
//  Created by Ben on 14/08/2016.
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

import UIKit
import Alamofire

class VideosDataSource: DataSource<VideosCollection> {

  var currentPage: Int {
    return Int(numberOfItems / type(of: self).pageSize)
  }

  static let pageSize = 20

  private let title: String
  fileprivate let categoryID: String

  // MARK: - Initialization

  init(categoryID: String = "", title: String? = nil) {
    self.title = title ?? ""
    self.categoryID = categoryID
    super.init(dataCollection: VideosCollection())
  }

  // MARK: - UICollectionViewDataSource

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(for: indexPath) as VideoCell
    cell.configure(with: dataCollection[indexPath.row])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath) as SectionHeaderView
      headerView.accessoryLabel.text = title
      return headerView
    }

    return UICollectionReusableView()
  }

}


extension VideosDataSource {

  var requestForNextPage: URLRequest {
    let url = iCookTVKeys.baseAPIURL + "categories/\(categoryID)/videos.json"
    let parameters = [
      "page[size]": type(of: self).pageSize,
      "page[number]": currentPage + 1
    ]

    do {
      let urlRequest = try URLRequest(url: url, method: .get)
      let encodedURLRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
      return encodedURLRequest
    } catch {
      fatalError("\(error)")
    }
  }

}
