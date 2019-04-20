//
//  DataSource.swift
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

class DataSource<Collection: DataCollection>: NSObject, SourceType {

  // MARK: - Initialization

  init(dataCollection: Collection) {
    self.dataCollection = dataCollection
  }

  // MARK: - SourceType

  private(set) var dataCollection: Collection

  var numberOfItems: Int {
    return dataCollection.count
  }

  subscript(index: Int) -> Collection.DataType {
    return dataCollection[index]
  }

  // MARK: - UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfItems
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    fatalError("Subclass must override this method.")
  }

  // MARK: - Public Methods

  func append(_ items: [Collection.DataType], toCollectionView collectionView: UICollectionView) {
    dataCollection = dataCollection.append(items)
    collectionView.reloadData()
  }

  func moveItem(atIndexPathToTop indexPath: IndexPath, inCollectionView collectionView: UICollectionView) {
    dataCollection = dataCollection.moveItem(fromIndex: indexPath.row, toIndex: 0)
    collectionView.reloadData()
  }
}
